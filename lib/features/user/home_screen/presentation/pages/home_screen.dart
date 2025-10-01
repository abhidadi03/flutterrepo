import 'package:flutter/material.dart';
import 'package:myfirstapp/config/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_bloc.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_state.dart';
import '../charts/users_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        context.go('/home');
      }
      if (index == 1) {
        context.push('/users');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsers());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  context.push('/profile');
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('Users'),
                onTap: () {
                  context.push('/users');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  context.go('/login');
                },
              )
            ],
          ),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserLoaded) {
            final users = state.users;
            print('users in the homw:-----${users}');
            for (var user in users) {
              print('userrrrrr-------${user.is_active}${user.name}');
            }
            return UsersPieChart(users: state.users);
          } else {
            return Text('No users found');
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "Users",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ]),
    );
  }
}
