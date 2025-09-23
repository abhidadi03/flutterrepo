import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/presentation/pages/user_form.dart';
import '../../domain/repository/user_repository.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:go_router/go_router.dart';

class ViewUserPage extends StatelessWidget {
  const ViewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    // create: (context) => UserBloc(UserRepository())..add(FetchUsers()),
    context.read<UserBloc>().add(FetchUsers());
    // child: BlocListener<UserBloc, UserState>(
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(FetchUsers());
                },
                // )
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(user.name[0])),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                final mainContext = context;
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text(
                                        'Do you want to edit this user?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          Navigator.push(
                                            mainContext,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                value: mainContext
                                                    .read<UserBloc>(),
                                                child: UserForm(user: user),
                                                // ),
                                              ),
                                            ),
                                          );
                                          // mainContext.push('/edit-user',
                                          //     extra: user);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () {
                                final blocContent = context;
                                showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                          title: const Text(
                                              'Do you want to delete this user'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  blocContent
                                                      .read<UserBloc>()
                                                      .add(DeleteUser(
                                                          id: user.id));
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text('Yes'))
                                          ],
                                        ));
                                print(user.id);
                                // context
                                //     .read<UserBloc>()
                                //     .add(DeleteUser(id: user.id));
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const Center(child: Text("No users found"));
          },
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              context.push('/add-user');
            }),
      ),
    );
  }
}
