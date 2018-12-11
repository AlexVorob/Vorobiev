
import Foundation

let accountant = Accountant( money: 0, name: "accountant Inna")
let director = Director(money: 0, name: "director Bob")
let washers = ["Alex", "Niko", "Bill", "Petro"].map { Washer(money: 0, name: $0) }

let washingService = CarWashingService(accountant: accountant, director: director, washersAvailable: washers)

var factory = CarFactory(carWashingService: washingService)

factory.timerTokenCarEmission()
//sleep(22)
//factory.stop()

RunLoop.current.run()
