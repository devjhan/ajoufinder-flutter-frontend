import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/views/home/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onSwitchToLogin; 
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController; 
  final TextEditingController nameController;
  final TextEditingController nickNameController;
  final TextEditingController descriptionController;
  final TextEditingController phoneNumberController;

  SignUpScreen({
    required this.onSwitchToLogin,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
    required this.nickNameController,
    required this.descriptionController,
    required this.phoneNumberController
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final (isSuccess, message) = await authViewModel.signUp(
        email: widget.emailController.text,
        password: widget.passwordController.text,
        name: widget.nameController.text,
        nickname: widget.nickNameController.text,
        phone: widget.phoneNumberController.text,
        description: widget.descriptionController.text,
        context: context,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message),),
      );

      if (isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(lostCategory: 'lost'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {   
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '회원가입',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                )
              ),
              SizedBox(height: 10,),
              Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '아직 계정이 없으신가요?\n'
                    ),
                    TextSpan(
                      text: '회원가입',
                      recognizer: TapGestureRecognizer()..onTap = widget.onSwitchToLogin,
                      style: TextStyle(color: theme.primaryColor)
                    )
                  ]
                ),
                ),
            ),
            SizedBox(height: 40,),
            Text(
              'email',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),                        
                TextFormField(
                  controller: widget.emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    //labelText: '이메일',
                    prefixIcon: Icon(Icons.email_outlined, color: theme.primaryColor,),
                    hintText: 'example@ajou.ac.kr',
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: theme.hintColor),
                    border: OutlineInputBorder(),
                    ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력하세요.';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)*ajou\.ac\.kr$').hasMatch(value)) {
                      return '아주대학교 계정만 사용할 수 있습니다.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'name',
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 14,
                    ),
                  ),
            SizedBox(height: 6),            
                  TextFormField(
                    controller: widget.nameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      //labelText: '이름',
                      prefixIcon: Icon(Icons.account_box_outlined, color: theme.primaryColor,),
                      hintText: '홍길동',
                      hintStyle: TextStyle(fontWeight: FontWeight.w300, color: theme.hintColor),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력하세요.';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 24,),
            Text(
              'nickname',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),            
                    TextFormField(
                      controller: widget.nickNameController,
                      obscureText: false,
                      decoration: InputDecoration(
                        //labelText: '닉네임',
                        prefixIcon: Icon(Icons.account_box_outlined, color: theme.primaryColor,),
                        border: OutlineInputBorder(),
                        ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '별명을 입력하세요.';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: 24),
            Text(
              'password',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),            
                      TextFormField(
                        controller: widget.passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          //labelText: '비밀번호',
                          prefixIcon: Icon(Icons.lock_outline, color: theme.primaryColor,),
                          border: OutlineInputBorder(),
                          suffix: IconButton(
                            onPressed: (){
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            }, 
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return '비밀번호를 입력하세요.';
                            }
                          return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(height: 24),
            Text(
              'confirm password',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),            
                          TextFormField(
                            controller: widget.confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              //labelText: '비밀번호 확인',
                              prefixIcon: Icon(Icons.lock_outline, color: theme.primaryColor,),
                              border: OutlineInputBorder(),
                              suffix: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                }, 
                                icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                              ),
                              validator: (value) {
                                if (value == null || (widget.passwordController.text != value)) {
                                  return '비밀번호와 검증 비밀번호가 맞지 않습니다.';
                                }
                                return null;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                          SizedBox(height: 24,),
            Text(
              'phone number',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),            
                          TextFormField(
                            controller: widget.phoneNumberController,
                            obscureText: false,
                            decoration: InputDecoration(
                              //labelText: '전화번호(선택)',
                              prefixIcon: Icon(Icons.local_phone_outlined, color: theme.primaryColor,),
                              hintStyle: TextStyle(fontWeight: FontWeight.w300, color: theme.hintColor),
                              hintText: '공란, 또는 01012345678',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value != null && !RegExp(r'^01[016789]\d{8}$').hasMatch(value)) {
                                return '공란, 또는 01012345678';
                              }
                              return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                          SizedBox(height: 24),
            Text(
              'description',
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),            
                          TextFormField(
                            controller: widget.descriptionController,
                            obscureText: false,
                            decoration: InputDecoration(
                              //labelText: '자기소개(선택)',
                              prefixIcon: Icon(Icons.text_fields_outlined, color: theme.primaryColor,),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              //테스트용 코드. 삭제할 것.
                              Provider.of<AuthViewModel>(context, listen : false).testlogin();
                              FocusScope.of(context).unfocus();
                              //_submitForm();
                            },
                            child: Text('회원가입'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                        ],
                      ),
                    )),
                  );
  }
}
