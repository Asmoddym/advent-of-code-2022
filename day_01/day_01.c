#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

void add_line_to_array(char *line, char ***array) {
  static int i = 1;

  (*array) = realloc(*array, sizeof(char *) * (i + 1));

  (*array)[i - 1] = strndup(line, strlen(line) - 1);
  (*array)[i] = NULL;

  i++;
}

char **parse_data() {
  FILE *file = fopen("input.txt", "r");
  char *line = NULL;
  ssize_t length;
  size_t cap = 0;
  char **array = NULL;

  while ((length = getline(&line, &cap, file)) > 0) {
    add_line_to_array(line, &array);
  }

  fclose(file);

  return array;
}

int *compute_total_calories_per_section(char **parsed_data) {
  int *total = NULL;

  int tmp = 0;
  int sections = 0;

  for (int i = 0; parsed_data[i] != NULL; i++) {
    if (!strcmp(parsed_data[i], "")) {
      sections++;

      total = realloc(total, sizeof(int) * (sections + 1));
      total[sections - 1] = tmp;
      total[sections] = -1;

      tmp = 0;
    } else {
      tmp += atoi(parsed_data[i]);
    }
  }

  return total;
}

int qsort_test(const void *a, const void *b) {
  int int_a = *(int *)a;
  int int_b = *(int *)b;

  return int_a > int_b ? -1 : (int_a < int_b ? 1 : 0);
}

int number_of_sections(int *sections) {
  int total = 0;

  for (int i = 0; sections[i] != -1; i++) {
    total++;
  }

  return total;
}

int main() {
  char **parsed_data = parse_data();
  int *total_per_section = compute_total_calories_per_section(parsed_data);

  qsort(total_per_section, number_of_sections(total_per_section), sizeof(int), &qsort_test);

  printf("%d, %d\n", total_per_section[0], (total_per_section[0] + total_per_section[1] + total_per_section[2]));

  for (int i = 0; parsed_data[i] != NULL; i++) {
    free(parsed_data[i]);
  }
  free(parsed_data);
  free(total_per_section);
}
