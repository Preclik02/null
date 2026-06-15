#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

    char input[2000];

    printf("NOTE >> ");
    fgets(input, sizeof(input), stdin);
    input[strcspn(input, "\n")] = '\0';

    FILE *file = fopen("todo.json", "a");

    fprintf(file, "{ \"note\": \"%s\" }\n", input);

    fclose(file);
   
    return 0;
}
