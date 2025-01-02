import 'package:flutter/material.dart';


class Book{
  final int id;
  final String title;
  final String author;
  final Container synopsis;

  Book(
    this.id,
    this.title,
    this.author,
    this.synopsis
  );

}

class BookRating {
  final int id;
  final int rating;
  final String title;
  final String author;
  final String synopsis;

  BookRating(
    this.id,
    this.title,
    this.author,
    this.synopsis,
    this.rating
  );

}