
import Foundation

let accountant = Accountant( money: 0, name: "accountant Inna", queue: .background)
let director = Director(money: 0, name: "director Bob", queue: .background)
let washers = ["Alex", "Niko", "Bill", "Petro"].map { Washer(money: 0, name: $0, queue: .background) }

let washingService = CarWashingService(accountant: accountant, director: director, washersAvailable: washers)

var factory = CarFactory(carWashingService: washingService)

factory.timerTokenCarEmission()
sleep(6)
factory.stop()

RunLoop.current.run()
