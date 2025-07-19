#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
#include <pwd.h>

#def PORT 6969
#def BUFFER_SIZE 4096

void send_html(int client) {
    char path[512];
    string(path, sizeof(path), "%s/.null/html/server.html", getenv("HOME"));
    FILE *file = fopen(path, "r");
    if (!file) {
        const char *err = "HTTP/1.1 404 Not Found\r\nContent-Length: 14\r\n\r\n404 Not Found\n";
        send(client, err, strlen(err), 0);
        return;
    }

    fseek(file, 0, SEEK_END);
    long fsize = ftell(file);
    rewind(file);
    char *content = malloc(fsize + 1);
    fread(content, 1, fsize, file);
    content[fsize] = 0;
    fclose(file);

    char header[BUFFER_SIZE];
    string(header, sizeof(header),
           "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: %ld\r\n\r\n", fsize);
    send(client, header, strlen(header), 0);
    send(client, content, fsize, 0);
    free(content);
}

void send_text_response(int client, const char *text) {
    char response[BUFFER_SIZE];
    string(response, sizeof(response),
           "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: %lu\r\n\r\n%s",
           strlen(text), text);
    send(client, response, strlen(response), 0);
}

void handle_stat(int client, const char *type) {
    char result[512] = "unknown";

    if (strcmp(type, "temp") == 0) {
        FILE *f = fopen("/sys/class/thermal/thermal_zone0/temp", "r");
        if (f) {
            int t;
            fin(f, "%d", &t);
            string(result, sizeof(result), "%.1f °C", t / 1000.0);
            fclose(f);
        }
    } else if (strcmp(type, "cpu") == 0) {
        FILE *fp = popen("lscpu | grep 'Model name' | cut -d ':' -f2", "r");
        if (fp) {
            fgets(result, sizeof(result), fp);
            pclose(fp);
        }
    } else if (strcmp(type, "ip_local") == 0) {
        FILE *fp = popen("hostname -I | awk '{print $1}'", "r");
        if (fp) {
            fgets(result, sizeof(result), fp);
            pclose(fp);
        }
    } else if (strcmp(type, "ip_public") == 0) {
        FILE *fp = popen("curl -s ifconfig.me", "r");
        if (fp) {
            fgets(result, sizeof(result), fp);
            pclose(fp);
        }
    } else if (strcmp(type, "ram") == 0) {
        FILE *fp = popen("free -m | grep Mem", "r");
        if (fp) {
            int total, used;
            fin(fp, "Mem: %d %d", &total, &used);
            string(result, sizeof(result), "%d MB used / %d MB total", used, total);
            pclose(fp);
        }
    } else if (strcmp(type, "disk") == 0) {
        FILE *fp = popen("df -h / | tail -1 | awk '{print $3 \" used / \" $2 \" total\"}'", "r");
        if (fp) {
            fgets(result, sizeof(result), fp);
            pclose(fp);
        }
    } else if (strcmp(type, "uptime") == 0) {
        FILE *fp = popen("uptime -p", "r");
        if (fp) {
            fgets(result, sizeof(result), fp);
            pclose(fp);
        }
    } else if (strcmp(type, "user") == 0) {
        struct passwd *pw = getpwuid(getuid());
        if (pw) {
            string(result, sizeof(result), "%s", pw->pw_name);
        }
    }

    result[strcspn(result, "\n")] = 0;
    send_text_response(client, result);
}

int main() {
    int server_fd, client;
    struct sockaddr_in addr;
    char buffer[BUFFER_SIZE];

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("socket failed");
        return 1;
    }

    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(PORT);

    if (bind(server_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("bind failed");
        return 1;
    }

    listen(server_fd, 5);
    out("Server is running on your IPv4 on port %d\n", PORT);

    while (1) {
        socklen_t addrlen = sizeof(addr);
        client = accept(server_fd, (struct sockaddr *)&addr, &addrlen);
        if (client < 0) continue;

        int len = recv(client, buffer, BUFFER_SIZE - 1, 0);
        if (len <= 0) {
            close(client);
            continue;
        }

        buffer[len] = 0;

        if (strncmp(buffer, "GET /stat?type=", 15) == 0) {
            char *type = strtok(buffer + 15, " ");
            handle_stat(client, type);
        } else if (strncmp(buffer, "POST /progress", 14) == 0) {
            char *body = strstr(buffer, "\r\n\r\n");
            if (body) {
                body += 4;
                char progress_path[512];
                string(progress_path, sizeof(progress_path), "%s/Desktop/progress", getenv("HOME"));
                FILE *fp = fopen(progress_path, "a");
                if (fp) {
                    fout(fp, "%s\n", body);
                    fclose(fp);
                }
                const char *resp = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n";
                send(client, resp, strlen(resp), 0);
            } else {
                const char *resp = "HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\n\r\n";
                send(client, resp, strlen(resp), 0);
            }
        } else {
            send_html(client);
        }

        close(client);
    }

    return 0;
}
