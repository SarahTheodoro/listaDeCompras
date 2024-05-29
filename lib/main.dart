// Realizado em aula com o professor (dias 1 e 2)

import 'package:flutter/material.dart';

void main() {
  runApp(Lista());
}

class Cliente {
  String nome;
  String categoria;
  String preco;

  Cliente({
    required this.nome,
    required this.categoria,
    required this.preco,
  });
}

class Lista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Adiciona a imagem do logo
                Image.asset(
                  'logo.jpg',
                  height: 244, // Ajuste conforme necessário
                  width: 275, // Ajuste conforme necessário
                ),

                // Adiciona a segunda imagem acima do logo
                Positioned(
                  top: 72, // Ajuste conforme necessário
                  child: Image.asset(
                    'logo.jpg',
                    height: 52.11, // Ajuste conforme necessário
                    width: 300, // Ajuste conforme necessário
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Verificar credenciais
                if (_usernameController.text == 'Sarah' &&
                    _passwordController.text == 'Sarah123') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentListPage()),
                  );
                } else {
                  // Exibir mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Credenciais inválidas')),
                  );
                }
              },
              child: Text('Login'),
            ),
            Text('Sarah'),
          ],
        ),
      ),
    );
  }
}

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  // Lista de alunos (simulando um banco de dados)
  List<Cliente> students = [
    Cliente(nome: 'Maça ', categoria: 'Fruta', preco: '7.0'),
    Cliente(nome: 'Banana ', categoria: 'Fruta', preco: '4.0'),
    Cliente(nome: 'Kiwi ', categoria: 'Fruta', preco: '5.4'),
    Cliente(nome: 'Macarrão ', categoria: 'Massa', preco: '10.65'),
    Cliente(nome: 'Lasanha ', categoria: 'Massa', preco: '11.66'),
    Cliente(nome: 'Rocamboli ', categoria: 'Doce', preco: '3.99'),
    Cliente(nome: 'Bolo ', categoria: 'Doce', preco: '34.0'),
    Cliente(nome: 'Pirulito ', categoria: 'Doce', preco: '8.99'),
    Cliente(nome: 'Coxinha ', categoria: 'Salgado', preco: '2.0'),
    Cliente(nome: 'Risoles ', categoria: 'Salgado', preco: '7.99'),
  ];

  bool _isValidEmail(String categoria) {
    // Validar o formato do email
    final categoriaRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return categoriaRegex.hasMatch(categoria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index].nome),
            subtitle: Text(students[index].categoria),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Excluir aluno
                students.removeAt(index);
                // Atualizar a interface
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Compra removido')),
                );
                // Atualizar a lista de alunos
                setState(() {});
              },
            ),
            onTap: () async {
              // Editar o aluno
              Cliente updatedStudent = await showDialog(
                context: context,
                builder: (context) {
                  TextEditingController _nomeController =
                      TextEditingController(text: students[index].nome);
                  TextEditingController _categoriaController =
                      TextEditingController(text: students[index].categoria);
                  TextEditingController _precoController =
                      TextEditingController(text: students[index].preco);

                  return AlertDialog(
                    title: Text('Editar Lista'),
                    content: Column(
                      children: [
                        TextField(
                          controller: _nomeController,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                        TextField(
                          controller: _categoriaController,
                          decoration: InputDecoration(labelText: 'Categoria'),
                        ),
                        TextField(
                          controller: _precoController,
                          decoration: InputDecoration(labelText: 'Preco'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Validar e salvar as alterações
                          if (_nomeController.text.isNotEmpty &&
                              _categoriaController.text.isNotEmpty &&
                              _isValidEmail(_categoriaController.text) &&
                              _precoController.text.isNotEmpty) {
                            Navigator.pop(
                              context,
                              Cliente(
                                nome: _nomeController.text.trim(),
                                categoria: _categoriaController.text.trim(),
                                preco: _precoController.text.trim(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Preencha todos os campos corretamente')),
                            );
                          }
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  );
                },
              );

              if (updatedStudent != null) {
                // Atualizar o aluno na lista
                students[index] = updatedStudent;
                // Atualizar a interface
                setState(() {});
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Adicionar novo aluno
          Cliente newStudent = await showDialog(
            context: context,
            builder: (context) {
              TextEditingController _nomeController = TextEditingController();
              TextEditingController _categoriaController =
                  TextEditingController();
              TextEditingController _precoController = TextEditingController();

              // Adicionar novo aluno
              return AlertDialog(
                title: Text('Nova Lista'),
                content: Column(
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      controller: _categoriaController,
                      decoration: InputDecoration(labelText: 'categoria'),
                    ),
                    TextField(
                      controller: _precoController,
                      decoration: InputDecoration(labelText: 'Preco'),
                    ),
                  ],
                ),
                // Cancelar operação
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  // Validar e adicionar o novo aluno
                  TextButton(
                    onPressed: () {
                      if (_nomeController.text.isNotEmpty &&
                          _categoriaController.text.isNotEmpty &&
                          _isValidEmail(_categoriaController.text) &&
                          _precoController.text.isNotEmpty) {
                        Navigator.pop(
                          context,
                          Cliente(
                            nome: _nomeController.text.trim(),
                            categoria: _categoriaController.text.trim(),
                            preco: _precoController.text.trim(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Preencha todos os campos corretamente')),
                        );
                      }
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );
          // Verificar espaço a ser alocado para a adição do novo aluno
          if (newStudent != null) {
            // Adicionar o novo aluno à lista
            students.add(newStudent);

            // Atualizar a tela
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
