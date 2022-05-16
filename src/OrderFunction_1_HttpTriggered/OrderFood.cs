using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace OrderFunction_1_HttpTriggered
{
    public static class OrderFood
    {
        [FunctionName(nameof(OrderFood))]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, nameof(HttpMethods.Post), Route = "order")] 
            OrderFoodRequest req,
            ILogger log)
        {
            Guid orderId = Guid.NewGuid();
            
            log.LogInformation("=============================================");
            log.LogInformation($"Order with orderID {orderId} has ben placed.");
            log.LogInformation($"{req.FoodName}; {req.Amount} gets from {req.RestaurantName}");
            log.LogInformation("=============================================");

            return new OkObjectResult(new
            {
                message = "Order is on the way",
                orderId = orderId
            });
        }
    }
}
