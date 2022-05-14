namespace OrderFunction_1_HttpTriggered
{
    public class OrderFoodRequest
    {
        public int RestaurantId { get; set; }
        public string RestaurantName { get; set; }
        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public int Amount { get; set; }
    }
}
