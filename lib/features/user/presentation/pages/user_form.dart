import 'package:flutter/material.dart';
import 'package:myfirstapp/features/user/domain/repository/user_repository.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_bloc.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_event.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_state.dart';
import 'package:myfirstapp/features/user/presentation/pages/view_user_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';
import '../../data/models/user_model.dart';
import 'package:go_router/go_router.dart';

class UserForm extends StatefulWidget {
  final UserModel? user;
  // const UserForm({super.key});
  const UserForm({super.key, this.user});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  bool _isButtonDisabled = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _nameController.addListener(_checkFields);
    _emailController.addListener(_checkFields);

    _checkFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
  }

  void _checkFields() {
    setState(() {
      _isButtonDisabled =
          _nameController.text.isNotEmpty && _emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Text(widget.user?'Add user':'Edit user'),
          title: Text(widget.user != null ? 'Edit user' : 'Add user'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User Created Successfully')));
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (_) => const HomePage()));
                // Navigator.pop(context);
                // context.go('/');
                context.pop();
                // Navigator.pop(context, true);
                // context.push('/');
                // GoRouter.of(context).go('/');
              }
              if (state is UserUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User Updated Successfully')));
                // Navigator.pop(context);
                context.pop();
              }
              if (state is UserError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                print('erro while creating:${state.message}');
              }
            },
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter your name" : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter your password" : null,
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                      return ElevatedButton(
                          onPressed: _isButtonDisabled
                              ? () async {
                                  try {
                                    print('22');
                                    if (_formKey.currentState!.validate()) {
                                      print('213');
                                      if (widget.user == null) {
                                        // context.read<UserBloc>().add(CreateUser(
                                        //     name: _nameController.text,
                                        //     email: _emailController.text));
                                      } else {
                                        print('editing1');
                                        context.read<UserBloc>().add(UpdateUser(
                                            id: widget.user!.id,
                                            name: _nameController.text,
                                            email: _emailController.text));
                                      }
                                    }
                                  } catch (e) {
                                    print('button error:$e');
                                  }
                                }
                              : null,
                          child: state is UserLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Submit'));
                    })
                  ],
                )),
          ),
        ));
  }
}
