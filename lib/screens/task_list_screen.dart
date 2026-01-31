import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hsb_kurir/screens/controller/task_controller.dart';
import 'package:hsb_kurir/widgets/location_status_card.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskController(),
      child: Scaffold(
        body: Consumer<TaskController>(builder: (context, state, _){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                LocationStatusCard(
                  isLoading: state.isLoading,
                  position: state.currentPosition,
                  error: state.error,
                  onRetry: () => state.getCurrentPosition(),
                ),

                ElevatedButton(onPressed: (){
                  context.read<TaskController>().captureStampedPhoto();
                }, child: Text("Ambil Foto")),

                if(state.picture != null)
                   Container(
                    child: Image.file(File(state.picture!.path)),
                   )
                
              ],
            ),
          );
        }),
    ));
  }
}
