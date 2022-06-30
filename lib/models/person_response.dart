import './person.dart';

class PersonResponse {
  final List<Person> persons;
  final String error;

  PersonResponse(this.persons, this.error);

  PersonResponse.fromJson(Map<String, dynamic> json)
      : persons = (json['results'] as List)
            .map((result) => Person.fromJson(result))
            .toList(),
        error = "";

  PersonResponse.withError(String errorValue)
      : persons = [],
        error = errorValue;
}
