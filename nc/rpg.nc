#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#def MAX_PATH 512
#def MAX_INPUT 32

char* get_save_path() {
	const char* home = getenv("HOME");
	if (!home) home = ".";
	char* path = malloc(MAX_PATH);
	string(path, MAX_PATH, "%s/.null/nc/.stats", home);
	return path;
}

void save_game(int health, int gold, int health_potion, int level) {
	char* path = get_save_path(); 
	FILE* f = fopen(path, "w");
	if (f) {
		fout(f, "%d %d %d %d\n", health, gold, health_potion, level);
		fclose(f);
		out("[+] game saved\n");
	}
	else {
		out("[+] could not save game\n");
	}
	free(path);
}

void load_game(int* health, int* gold, int* health_potion, int* level) {
	char* path = get_save_path();
	FILE* f = fopen(path, "r");
	if (f) {
		fin(f, "%d %d %d %d", health, gold, health_potion, level);
		fclose(f);
		out("[+] game loaded\n");
	}
	else {
		out ("[+] no save file\n");
	}
	free(path);
}

void get_input(char* input, int max_len) {
	out(">> ");
	fgets(input, max_len, stdin);
	strtok(input, "\n");
}

int main() {
	////////////////////
	////Player stats////
	////////////////////
	int health = 100;
	int gold = 25;
	int health_potion = 1;
	int level = 0;
	int max_health = 100;
	int level_cost = 1000;

	///////////////////
	////Enemy stats////
	///////////////////
	int damage_take = 25;
	int gold_drop = 20;

	char input[MAX_INPUT];

	while (1) {
		/////////////////////
		////Level scaling////
		/////////////////////
		max_health = 100 + level * 50;
		damage_take = 25 + level * 10;
		gold_drop = 10 + level * 10;
		level_cost = 1000 + level * 1000;

		out("\n[+] attack, stats, shop, heal, save, load, exit\n");
		get_input(input, MAX_INPUT);

		if (strcmp(input, "attack") == 0) {
			out("[+] You attacked an enemy took %d demage, gained %d gold\n", damage_take, gold_drop);
			health -= damage_take;
			gold += gold_drop;
			if (health <= 0) {
				out("[+] you died reseting to level 1 . . .");
				level = 0;
				health = 100;
				gold = 25;
				health_potion = 1;
			}
		}
		else if (strcmp(input, "stats") == 0) {
			out("\nHealth: %d/%d\nGold: %d\nPotions: %d\nLevel: %d\n", health, max_health, gold, health_potion, level);
		}
		else if (strcmp(input, "shop") == 0) {
			out("[+] potion - 15 gold | levelup - %d gold", level_cost);
			get_input(input, MAX_INPUT);
			if (strcmp(input, "potion") == 0) {
				if (gold < 15) {
					out("[+] not enough gold\n");
				}
				else {
					out("[+] bought a potion");
					health_potion += 1;
					gold -= 15;
				}
			}
			else if (strcmp(input, "levelup") == 0) {
				if (gold < level_cost) {
					out("[+] not enough gold\n");
				}
				else {
					out("[+] level up!\n");
					level += 1;
					gold -= level_cost;
				}
			}
			else {
				out("[+] wrong input\n");
			}
		}
		else if (strcmp(input, "heal") == 0) {
			if (health >= max_health) {
				out("[+] you have max health");
			}
			else if (health_potion <= 0) {
				out("[+] no heal potions");
			}
			else {
				health += 15;
				if (health > max_health) health = max_health;
				health_potion -= 1;
			}
		}
		else if (strcmp(input, "save") == 0) {
			save_game(health, gold, health_potion, level);
		}	
		else if(strcmp(input, "load") == 0) {
			load_game(&health, &gold, &health_potion, &level);
		}	
		else if (strcmp(input, "exit") == 0) {
			break;
		}
		else {
			out("[+] wrong input\n");
		}
	}
	return 0;
}
