import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
        height: 50.0,
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  bool obscureText = false,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  required FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  VoidCallback? ontap,
  bool isClickable=true
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
            icon: Icon(suffix),
          onPressed:suffixPressed
        ),
        border: OutlineInputBorder(),
      ),
      onTap:ontap ,
      enabled: isClickable,
    );

Widget buildTaskItem(
    Map model,
    BuildContext context, {
      IconData? doneIcon,
      VoidCallback? onDonePressed,
      Color? doneIconColor,
      IconData? archiveIcon,
      VoidCallback? onArchivePressed,
    }) =>
    Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFD6AA59),
              radius: 40.0,
              child: Text(
                "${model['time']}",
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            if (doneIcon != null && onDonePressed != null)
              IconButton(
                onPressed: onDonePressed,
                icon: Icon(
                  doneIcon,
                  color: doneIconColor,
                ),
              ),
            if (archiveIcon != null && onArchivePressed != null)
              IconButton(
                onPressed: onArchivePressed,
                icon: Icon(
                  archiveIcon,
                  color: Colors.black45,
                ),
              ),
          ],
        ),
      ),
    );

Widget tasksBuilder({
  required List<Map> tasks,
  IconData? doneIcon,
  Color? doneIconColor=Colors.green,
  void Function(int index)? onDonePressed,
  IconData? archiveIcon,
  void Function(int index)? onArchivePressed,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(
          tasks[index],
          context,
          doneIcon: doneIcon,
          doneIconColor:doneIconColor ,
          onDonePressed: onDonePressed != null ? () => onDonePressed(index) : null,
          archiveIcon: archiveIcon,
          onArchivePressed: onArchivePressed != null ? () => onArchivePressed(index) : null,
        ),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
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
              "No Tasks Yet, Please Add Some Tasks",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
