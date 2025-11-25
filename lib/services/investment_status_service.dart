import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/models/investment_status_card_model.dart';

import '../constants/app_constant.dart';
import '../main.dart';
import '../services/api_service.dart';

class InvestmentStatusService {
  Future<String?> _token() async => storage.read(AppConst.ACCESS_TOKEN);

  final String url = AppURLs.INVESTMENT_STATUS_API;
   
  // Fetch Investment Status
  Future<InvestmentStatusResponse?> fetchInvestmentStatus() async {
    final token = await _token();

    return APIService.getRequest<InvestmentStatusResponse>(
      url: url,
      headers: {"Authorization": "Bearer $token"},
      onSuccess: (json) => InvestmentStatusResponse.fromJson(json),
    );
  }
}
