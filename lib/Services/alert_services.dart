import 'package:chatapp/Services/navigation_services.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AlertServices {
  final GetIt getit = GetIt.instance;
 late NavigationService _navigationService;
 
  AlertServices() {
_navigationService = getit.get<NavigationService>();

  }


   
  void showToast({required String text, IconData icon = Icons.info}) {
    try {
      DelightToastBar(
          autoDismiss: true,
          position: DelightSnackbarPosition.top,
          builder: (context) {
            return ToastCard(
              leading: Icon(icon , size: 20,),
                title: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ));
          }
          ).show(_navigationService.navigatorKey.currentContext!);
    } catch (e) {
      print(e);
    }
  }
}
