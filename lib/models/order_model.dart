
class OrderModel{
   String id;
   String name;
   String color;
   String storage;
   int price;
   int qty;
   String image;
   String dailyPlan;
   String status; 
   String openDate;
   String closeDate;
   int invested;

  OrderModel({
    required this.id,
    required this.name,
    required this.color,
    required this.storage,
    required this.price,
    required this.qty,
    required this.image,
    required this.dailyPlan,
    required this.status,
    required this.openDate,
    required this.closeDate,
    required this.invested,
  });
}