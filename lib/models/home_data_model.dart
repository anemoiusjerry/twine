import 'package:twine/models/couple_model.dart';
import 'package:twine/models/partner_settings_model.dart';

class HomeDataModel {
  final Couple? coupleInfo;
  final PartnerSettings? partnerSettings;
  final String imageUrl;
  final String storagePath;

  HomeDataModel(
    this.coupleInfo,
    this.partnerSettings, 
    this.imageUrl,
    this.storagePath,
  );
}