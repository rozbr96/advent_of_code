
#include <stdio.h>
#include <stdlib.h>


#define MAX_LINE_LENGTH 140
// #define MAX_LINE_LENGTH 10
#define IS_PART_NUMBER 1
#define IS_NOT_PART_NUMBER 0


typedef struct {
  int lines_amount;
  char **elements;
} matrix_t;


int check_is_part_digit(matrix_t *matrix, int row, int col) {
  for ( int i = row - 1; i <= row + 1; i++ ) {
    if (i == -1 || i == matrix->lines_amount) continue;

    for ( int j = col - 1; j <= col + 1; j++ ) {
      if (j == -1 || j == MAX_LINE_LENGTH) continue;

      if (
        (matrix->elements[i][j] < 48 || matrix->elements[i][j] > 57)
          && matrix->elements[i][j] != 46
      ) return IS_PART_NUMBER;
    }
  }

  return IS_NOT_PART_NUMBER;
}

FILE* read_file(char *filename) {
  FILE *file;

  if (!(file = fopen(filename, "r")))
    exit(EXIT_FAILURE);

  return file;
}

int get_lines_amount(FILE *file) {
  fseek(file, 0, SEEK_END);

  return (ftell(file) + 1) / (MAX_LINE_LENGTH + 1);
}

int get_part_numbers_sum(matrix_t *matrix) {
  int number = 0;
  int is_part_number = 0;
  int part_numbers_sum = 0;

  for ( int row = 0; row < matrix->lines_amount; row++ ) {
    for ( int col = 0; col < MAX_LINE_LENGTH; col++ ) {
      if (matrix->elements[row][col] >= 48 && matrix->elements[row][col] <= 57) {
        if (!is_part_number) is_part_number = check_is_part_digit(matrix, row, col);

        int digit = matrix->elements[row][col] - 48;

        number *= 10;
        number += digit;
      } else {
        if (is_part_number) part_numbers_sum += number;

        number = 0;
        is_part_number = IS_NOT_PART_NUMBER;
      }
    }

    if (is_part_number) part_numbers_sum += number;

    number = 0;
    is_part_number = IS_NOT_PART_NUMBER;
  }

  return part_numbers_sum;
}

matrix_t* init_matrix(FILE *file) {
  int line_index = 0;
  matrix_t *matrix;

  matrix = malloc(sizeof(matrix_t));
  matrix->lines_amount = get_lines_amount(file);
  matrix->elements = calloc(matrix->lines_amount, sizeof(char *));

  for ( int i = 0; i < matrix->lines_amount; i++ )
    matrix->elements[i] = calloc(MAX_LINE_LENGTH, sizeof(char));

  rewind(file);
  while (!feof(file)) fscanf(file, "%s", matrix->elements[line_index++]);

  return matrix;
}

int main() {
  // FILE *file = read_file("samples/part_one.txt");
  FILE *file = read_file("input.txt");
  matrix_t *matrix = init_matrix(file);

  printf("%d\n", get_part_numbers_sum(matrix));

  return EXIT_SUCCESS;
}
