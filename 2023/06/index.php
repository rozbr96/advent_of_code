<?php

// $text = file_get_contents("samples/part_one.txt");
$text = file_get_contents("input.txt");

$lines = explode("\n", $text);
[$times, $distances] = array_map(function (string $line) {
  $numbersPart = explode(":", $line)[1];
  $numbersStrings = preg_split("/\s+/", $numbersPart);
  $numbers = array_map(function ($value) {
    return intval($value);
  }, $numbersStrings);

  array_shift($numbers);

  return $numbers;
}, $lines);


$margin_of_error = 1;
for ( $index = 0; $index < count($times); $index++ ) {
  $time = $times[$index];
  $highest_distance_record = $distances[$index];

  $possible_wins = 0;
  for ( $current_time = 0; $current_time < $time; $current_time++) {
    $distance = -$current_time ** 2 + $time * $current_time;

    if ($distance > $highest_distance_record)
      $possible_wins += 1;
  }

  $margin_of_error *= $possible_wins;
}

echo $margin_of_error;
