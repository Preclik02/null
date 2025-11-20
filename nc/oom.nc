// ----- oom.c ----- //

// --- potencial updates --- //
// Ask user if they wanna save game when quiting. //

// --- needed updates --- //
// Make the Gaamble function with actual events. //
// Make the fight mechanic for all the cases. //

// --- developer notes --- //
// use %llu when working with variable "usage"


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

void *ram = NULL;

void refresh_ram(size_t usage) {
  if (ram != NULL) free(ram);
  ram = malloc(usage);
  if (!ram) {
    out("[-] Failed to allocate %zu bytes of RAM!\n", usage);
    exit(1);
  }
  out("[+] Refreshed %zu bytes of RAM.\n", usage);
}

void calculate_usage(int calc_usage, int health, int max_health, unsigned long long *usage) {
  calc_usage = max_health - health;
  *usage += (unsigned long long)calc_usage * 100000000ULL;
}

void restore_e(int *e_health) {
  *e_health = 25;
}


int main() {

  out("\n\n[+] Please be aware of the gamble command look at README.md before you decide to roll\n\n");

  srand(time(NULL));

  // ----- FUNCTIONAL VARIABLES ----- //
  char x[256];

  int gamble_num;
  int gamble_enemy;
  int calc_usage;

  // ----- RAM VARIABLES ----- //
  unsigned long long usage = 0;
  int update;

  // ----- GAME VARIABLES ----- //

  // --- PLAYER --- //
  int health = 100;
  int max_health = 100;
  int demage = 10;
  int heal = 15;
  // --- ENEMY --- //
  int e_health = 25;
  int e_demage = 5;

  // ----- MAIN LOOP  ----- //
  while (1) {
    restore_e(&e_health);
    calculate_usage(calc_usage, health, max_health, &usage);
    refresh_ram(usage);

    if (health <= 0) {
      out("\n\n[+] You have died adding ram . . .\n\n");
      //usage = 1000000000000ULL;
      usage = 100000000000;
      refresh_ram(usage);
      sleep(30);
    }

    out("\n[-] Action >> ");
    in("%255s", x);

    if (strcmp(x, "help") == 0) {
      out("\n[+] | fight | help | stats | gamble | ... | quit |\n\n");
    }

    else if (strcmp(x, "fight") == 0) {
      out("\n[+] You roll witch enemy to fight . . .\n");

      gamble_enemy = rand() % 5 + 1;

      switch(gamble_enemy) {
        case 1:
          out("\n\n[+] You rolled \"goblin\"\n");
          out("[+] His stats are\nHealth >> %d\nDemage >> %d", e_health, e_demage);
          while (e_health > 0 && health > 0) {
            e_health -= demage;
            health -= e_demage;
          }
        break;
        case 2:
          // make custom stats if needed
          out("\n\n[+] You rolled \"jaylub\"\n");
          out("[+] His stats are \nHealth >> %d\nDemage >> %d", e_health, e_demage);
          while (e_health > 0 && health > 0) {
            e_health -= demage;
            health -= e_demage;
          }
          break;
        case 3:
          // make custom values or stats if needed as said before
          out("\n\n[+] You rolled \"snazivec\"\n");
          out("[+] His stats are \nHealth >> %d\nDemage >> %d", e_health, e_demage);
          while (e_health > 0 && health > 0) {
            e_health -= demage;
            health -= e_demage;
          }
          break;
        case 4:
          out("\n\n[+] Your rolled \"Tatarka\"\n");
          out("[+] His stats are \nHealth >> %d\nDemage >> %d", e_health, e_demage);
          while (e_health > 0 && health > 0) {
            e_health -= demage;
            health -= e_demage;
          }
          break;
        case 5:
          out("\n\n[+] You rolled \"iron man\"\n");
          out("[+] His stats are \nHealth >> %d\nDemage >> %d", e_health, e_demage);
          while (e_health > 0 && health > 0) {
            e_health -= demage;
            health -= e_demage;
          }
          break;
        default:
          out("\n[+] Something fucked up\n");
          break;
      }
    }

    else if (strcmp(x, "stats") == 0) {
      out("\n[+] Usage >> %llu\nHealth >> %d\nDemage >> %d\nHeal >> %d\n\n", usage, health, demage, heal);
    }

    else if (strcmp(x, "gamble") == 0) {
      gamble_num = rand() % 5 + 1;
      switch (gamble_num) {
        case 1:
          out("\n[+] Rolled 1 --> MAX HEALTH");
          health = max_health;
          break;
        case 2:
          out("\n[+] Rolled 2 --> DEMAGE +5");
          demage += 5;
          break;
        case 3:
          out("\n[+] Rolled 3 --> ... ");
          break;
        case 4:
          out("\n[+] Rolled 4 --> ... ");
          break;
        case 5:
          out("\n[+] Rolled 5 --> Instant death");
          health = 0;
          break;
        default:
          out("\n[+] Something fucked up\n\n");
          break;
      }
    }




    else if (strcmp(x, "quit") == 0) {
      break;
    }
  }

  return 0;
}
