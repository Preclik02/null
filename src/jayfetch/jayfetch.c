#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/utsname.h>
#include <sys/sysinfo.h>
#include <unistd.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h> // <-- Added this to fix the NI_MAXHOST and getnameinfo errors

#define BUFFER_SIZE 256

// Color Configurations
#define COLOR_LOGO  "\033[1;36m" // Bold Cyan
#define COLOR_TITLE "\033[1;35m" // Bold Magenta
#define COLOR_LABEL "\033[1;33m" // Bold Yellow
#define COLOR_RESET "\033[0m"

// Helper to remove trailing newlines and spaces
void trim_backspace(char *str) {
    int len = strlen(str);
    while (len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r' || str[len - 1] == ' ')) {
        str[--len] = '\0';
    }
}

// 1. Fetch OS Name
void get_os_name(char *os_name) {
    FILE *fp = fopen("/etc/os-release", "r");
    if (!fp) {
        strcpy(os_name, "Linux");
        return;
    }
    char line[BUFFER_SIZE];
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "PRETTY_NAME=", 12) == 0) {
            char *start = strchr(line, '"');
            if (start) {
                start++;
                char *end = strrchr(start, '"');
                if (end) *end = '\0';
                strncpy(os_name, start, BUFFER_SIZE);
            } else {
                strncpy(os_name, line + 12, BUFFER_SIZE);
                trim_backspace(os_name);
            }
            break;
        }
    }
    fclose(fp);
}

// 2. Fetch CPU Model Name
void get_cpu_name(char *cpu_name) {
    FILE *fp = fopen("/proc/cpuinfo", "r");
    if (!fp) {
        strcpy(cpu_name, "Unknown Processor");
        return;
    }
    char line[BUFFER_SIZE];
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "model name", 10) == 0) {
            char *colon = strchr(line, ':');
            if (colon) {
                colon += 2; // Skip past colon and space
                strncpy(cpu_name, colon, BUFFER_SIZE);
                trim_backspace(cpu_name);
                break;
            }
        }
    }
    fclose(fp);
}

// 3. Fetch Active Shell Name
void get_shell_name(char *shell_name) {
    char *env_shell = getenv("SHELL");
    if (env_shell) {
        char *token = strrchr(env_shell, '/');
        if (token) {
            strcpy(shell_name, token + 1);
        } else {
            strcpy(shell_name, env_shell);
        }
    } else {
        strcpy(shell_name, "Unknown");
    }
}

// 4. Fetch Local IP Address
void get_local_ip(char *ip_addr) {
    struct ifaddrs *ifaddr, *ifa;
    strcpy(ip_addr, "127.0.0.1"); // Fallback

    if (getifaddrs(&ifaddr) == -1) return;

    for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
        if (ifa->ifa_addr == NULL) continue;

        int family = ifa->ifa_addr->sa_family;
        if (family == AF_INET) { // IPv4 check
            char host[NI_MAXHOST];
            if (getnameinfo(ifa->ifa_addr, sizeof(struct sockaddr_in), host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST) == 0) {
                // Ignore loopback interface
                if (strcmp(ifa->ifa_name, "lo") != 0) {
                    strncpy(ip_addr, host, BUFFER_SIZE);
                    break;
                }
            }
        }
    }
    freeifaddrs(ifaddr);
}

int main() {
    // Collect Host/User info
    char username[BUFFER_SIZE] = "user", hostname[BUFFER_SIZE] = "host";
    getlogin_r(username, sizeof(username));
    gethostname(hostname, sizeof(hostname));

    // System Stats
    struct utsname buffer;
    uname(&buffer);

    struct sysinfo info;
    sysinfo(&info);
    long uptime_secs = info.uptime;
    int days = uptime_secs / 86400, hours = (uptime_secs % 86400) / 3600, mins = (uptime_secs % 3600) / 60;
    long total_ram = (info.totalram * info.mem_unit) / 1024 / 1024;
    long used_ram = total_ram - ((info.freeram * info.mem_unit) / 1024 / 1024);

    // Advanced lookups
    char os_name[BUFFER_SIZE], cpu_name[BUFFER_SIZE], shell_name[BUFFER_SIZE], ip_addr[BUFFER_SIZE];
    get_os_name(os_name);
    get_cpu_name(cpu_name);
    get_shell_name(shell_name);
    get_local_ip(ip_addr);

    // Your Logo
    const char *logo[] = {
        "                     ▄▄▄▄       ",
        "                   ▄ ██████     ",
        "               ▄▄▄▄▄ ██████     ",
        "           ▄▄▄▄▄▄▄▄▄ ██████     ",
        "       ▄▄▄▄▄▄▄▄▄▄▄▄▄ ██████     ",
        "              ██████ ██████     ",
        "              ██████ ██████     ",
        "              ██████ ██████     ",
        "              ██████ ██████     ",
        "              ██████ ██████     ",
        "              ██████ ██████   ▄▄",
        "    ▄▄▄       ██████ ███  ▄▄▄▄▄▄  ",
        " ▄█████       ██████   ▄▄▄▄▄▄▄    ",
        " ██████     ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄      ",
        " ███████████████  ▄▄▄▄▄▄▄         ",
        "   ██████████  ▄▄▄▄▄▄▄            ",
        "      █████ ▄▄▄▄▄▄▄▄              ",
        "          ▄▄▄▄▄▄▄                 ",
        "            ▄▄                    "
    };
    int logo_lines = sizeof(logo) / sizeof(logo[0]);

    // Build Stats Grid
    char stats[20][BUFFER_SIZE];
    for (int i = 0; i < 20; i++) strcpy(stats[i], "");

    snprintf(stats[2],  BUFFER_SIZE, COLOR_TITLE "%s" COLOR_RESET "@" COLOR_TITLE "%s", username, hostname);
    snprintf(stats[3],  BUFFER_SIZE, "----------------------------------------");
    snprintf(stats[4],  BUFFER_SIZE, COLOR_LABEL "OS     " COLOR_RESET " %s", os_name);
    snprintf(stats[5],  BUFFER_SIZE, COLOR_LABEL "Kernel " COLOR_RESET " %s", buffer.release);
    if (days > 0) 
        snprintf(stats[6], BUFFER_SIZE, COLOR_LABEL "Uptime " COLOR_RESET " %dd %dh %dm", days, hours, mins);
    else 
        snprintf(stats[6], BUFFER_SIZE, COLOR_LABEL "Uptime " COLOR_RESET " %dh %dm", hours, mins);
    
    snprintf(stats[7],  BUFFER_SIZE, COLOR_LABEL "Shell  " COLOR_RESET " %s", shell_name);
    snprintf(stats[8],  BUFFER_SIZE, COLOR_LABEL "CPU    " COLOR_RESET " %s", cpu_name);
    snprintf(stats[9],  BUFFER_SIZE, COLOR_LABEL "Memory " COLOR_RESET " %ldMiB / %ldMiB", used_ram, total_ram);
    snprintf(stats[10], BUFFER_SIZE, COLOR_LABEL "Local IP" COLOR_RESET " %s", ip_addr);
    
    // Terminal color blocks at row 12
    snprintf(stats[12], BUFFER_SIZE, 
             "\033[40m   \033[41m   \033[42m   \033[43m   \033[44m   \033[45m   \033[46m   \033[47m   \033[0m");

    // Print execution output side-by-side
    for (int i = 0; i < logo_lines; i++) {
        printf(COLOR_LOGO "%s" COLOR_RESET "  %s\n", logo[i], stats[i]);
    }

    return 0;
}
