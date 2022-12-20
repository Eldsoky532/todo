import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo/style/style.dart' as Style;

import '../bloc/cubic.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  //required Function onSubmit(),
  // required Function onChange(),
  Function()? onTap,
  bool isPassword = false,
  required Function? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,

      // onFieldSubmitted: onSubmit,
      // onChanged: onChange,
      onTap: onTap,
      validator: (value) {
        return validate!(value);
      },
      decoration: InputDecoration(

        fillColor:Style.Colors.maincolor,
        suffixIconColor: Style.Colors.maincolor,
        labelText: label,
        prefixIcon: Icon(
          prefix,
            color: Style.Colors.maincolor
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed!(),
                icon: Icon(
                  suffix,
                  color: Style.Colors.maincolor,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color:Style.Colors.maincolor )
        )

      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function() function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultappbar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_left)),
      title: Text(title!),
      actions: actions,
    );

Widget defaultTextButton({
  required Function() function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          height: 30,
          width: 30,
          child: CircleAvatar(
            radius: 40.0,
            child: Image(
                image: AssetImage('asset/img/mm.png')
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    '(${model['time']})',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        IconButton(
          onPressed: ()
          {
            AppCubit.get(context).updateData(
              status: 'done',
              id: model['id'],
            );
          },
          icon: Icon(

            Icons.check_box,
            color: Style.Colors.maincolor,
          ),
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateData(
              status: 'archive',
              id: model['id'],
            );
          },
          icon: Icon(
            Icons.archive,
            color: Colors.black45,
          ),
        ),
      ],
    ),
  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id'],);
  },
);

Widget tasksBuilder({
  required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index)
    {
      return buildTaskItem(tasks[index], context);
    },
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);
