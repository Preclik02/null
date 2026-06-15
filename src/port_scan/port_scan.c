#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <pthread.h>
#include <fcntl.h>
#include <errno.h>

#define MAX_THREADS 50
#define TIMEOUT_SEC 1

// Structure to pass arguments to the threads
typedef struct {
    char ip_str[32]; // Increased from 16 to 32 to prevent format-truncation warning
    int port;
} ScanArgs;

// Thread function to check a single IP and port
void* check_port(void* args) {
    ScanArgs* scan_data = (ScanArgs*)args;
    int sock;
    struct sockaddr_in server;
    
    // Create socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        free(scan_data);
        pthread_exit(NULL);
    }

    // Set socket to non-blocking mode to implement custom timeout
    int flags = fcntl(sock, F_GETFL, 0);
    fcntl(sock, F_SETFL, flags | O_NONBLOCK);

    server.sin_addr.s_addr = inet_addr(scan_data->ip_str);
    server.sin_family = AF_INET;
    server.sin_port = htons(scan_data->port);

    // Attempt connection
    int res = connect(sock, (struct sockaddr *)&server, sizeof(server));
    
    if (res < 0) {
        if (errno == EINPROGRESS) {
            fd_set fdset;
            struct timeval tv;

            FD_ZERO(&fdset);
            FD_SET(sock, &fdset);
            
            tv.tv_sec = TIMEOUT_SEC;
            tv.tv_usec = 0;

            // Wait for the socket to become writable (connection established)
            res = select(sock + 1, NULL, &fdset, NULL, &tv);
            
            if (res > 0) {
                int so_error;
                socklen_t len = sizeof(so_error);
                getsockopt(sock, SOL_SOCKET, SO_ERROR, &so_error, &len);
                
                if (so_error == 0) {
                    printf("[+] Found: %s has port %d OPEN\n", scan_data->ip_str, scan_data->port);
                }
            }
        }
    } else {
        // Immediate connection
        printf("[+] Found: %s has port %d OPEN\n", scan_data->ip_str, scan_data->port);
    }

    close(sock);
    free(scan_data);
    pthread_exit(NULL);
}

int main() {
    char base_ip[16];
    int port;

    printf("=== Manual Local Network Port Scanner (C) ===\n");
    
    // 1. Get the base network (e.g., 192.168.1)
    printf("Enter the first 3 octets of your local network (e.g., 192.168.1): ");
    if (scanf("%15s", base_ip) != 1) return 1;

    // 2. Get the target port
    printf("Enter the port to scan: ");
    if (scanf("%d", &port) != 1 || port < 1 || port > 65535) {
        printf("[-] Invalid port.\n");
        return 1;
    }

    printf("\n[*] Scanning range %s.1 to %s.254 for port %d...\n\n", base_ip, base_ip, port);

    pthread_t threads[255];

    // 3. Loop through host addresses 1 to 254
    for (int i = 1; i <= 254; i++) {
        ScanArgs* args = malloc(sizeof(ScanArgs));
        snprintf(args->ip_str, sizeof(args->ip_str), "%s.%d", base_ip, i);
        args->port = port;

        // Create thread to scan this specific IP
        pthread_create(&threads[i], NULL, check_port, (void*)args);

        // Throttle thread creation slightly so we don't overwhelm the OS file descriptors
        if (i % MAX_THREADS == 0) {
            for (int j = i - MAX_THREADS + 1; j <= i; j++) {
                pthread_join(threads[j], NULL);
            }
        }
    }

    // Join any remaining active threads
    for (int i = 254 - (254 % MAX_THREADS) + 1; i <= 254; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("\n=== Scan Complete ===\n");
    return 0;
}
