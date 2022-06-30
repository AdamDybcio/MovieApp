import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/bloc/get_persons_bloc.dart';

import '../models/person.dart';
import '../models/person_response.dart';
import '../style/theme.dart' as Style;

class PersonsList extends StatefulWidget {
  const PersonsList({Key key}) : super(key: key);

  @override
  State<PersonsList> createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  void initState() {
    super.initState();
    personsBloc.getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          child: Text(
            'TRENDING PERSONS ON THIS WEEK',
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<PersonResponse>(
            stream: personsBloc.subject.stream,
            builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error.isNotEmpty) {
                  return _buildErrorWidget(snapshot.data.error);
                }
                return _buildPersonsWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error as String);
              } else {
                return _buildLoadingWidget();
              }
            }),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Container(
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading Persons...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error occured: $error',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonsWidget(PersonResponse data) {
    List<Person> persons = data.persons;
    return Container(
      height: 130,
      padding: const EdgeInsets.only(left: 10),
      child: ListView.builder(
        itemCount: persons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                persons[index].profileImg == null
                    ? Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Style.Colors.secondColor,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.userLarge,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w200${persons[index].profileImg}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  persons[index].name,
                  maxLines: 2,
                  style: const TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Trending for ${persons[index].known}',
                  style: const TextStyle(
                    color: Style.Colors.titleColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
