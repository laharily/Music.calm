import Foundation
 
// STEP 1: MUST import HealthKit
import HealthKit
 
@available(iOS 13.0, *)
class HealthKitInterface
{
    var tot = 200
    var count = 0
    // STEP 2: a placeholder for a conduit to all HealthKit data
    let healthKitDataStore: HKHealthStore?
    
    // STEP 3: create member properties that we'll use to ask
    // if we can read and write heart rate data
    let readableHKQuantityTypes: Set<HKQuantityType>?
    let writeableHKQuantityTypes: Set<HKQuantityType>?
  
    @available(iOS 13.0, *)
    init(_ home: HomePageViewController) {
        
        // STEP 4: make sure HealthKit is available
        if HKHealthStore.isHealthDataAvailable() {
            
            // STEP 5: create one instance of the HealthKit store
            // per app; it's the conduit to all HealthKit data
            self.healthKitDataStore = HKHealthStore()
            
            let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
            
            // STEP 9.2: define a query for "recent" heart rate data;
            // in pseudo-SQL, this would look like:
            //
            // SELECT bpm FROM HealthKitStore WHERE qtyTypeID = '.heartRate';
            
            // STEP 6: create two Sets of HKQuantityTypes representing
            // heart rate data; one for reading, one for writing
            readableHKQuantityTypes = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
            writeableHKQuantityTypes = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
            
            // STEP 7: ask user for permission to read and write
            // heart rate data
            healthKitDataStore?.requestAuthorization(toShare: writeableHKQuantityTypes,
                                                     read: readableHKQuantityTypes,
                                                     completion: { (success, error) -> Void in
                if success {
                    print("Successful authorization.")
                } else {
                    print(error.debugDescription)
                }
            })
            
        } // end if HKHealthStore.isHealthDataAvailable()
        
        else {
            
            self.healthKitDataStore = nil
            self.readableHKQuantityTypes = nil
            self.writeableHKQuantityTypes = nil
            
            
            
        }
    } // end init()
    
    // STEP 8.0: this is my wrapper for writing one heart
    // rate sample at a time to the HKHealthStore
    func writeHeartRateData( heartRate: Int ) -> Void {
        // STEP 8.1: "Count units are used to represent raw scalar values. They are often used to represent the number of times an event occurs"
        let heartRateCountUnit = HKUnit.count()
        // STEP 8.2: "HealthKit uses quantity objects to store numerical data. When you create a quantity, you provide both the quantity’s value and unit."
        // beats per minute = heart beats / minute
        let beatsPerMinuteQuantity = HKQuantity(unit: heartRateCountUnit.unitDivided(by: HKUnit.minute()), doubleValue: Double(heartRate))
        // STEP 8.3: "HealthKit uses quantity types to create samples that store a numerical value. Use quantity type instances to create quantity samples that you can save in the HealthKit store."
        // Short-hand for HKQuantityTypeIdentifier.heartRate
        let beatsPerMinuteType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        // STEP 8.4: "you can use a quantity sample to record ... the user's current heart rate..."
        let heartRateSampleData = HKQuantitySample(type: beatsPerMinuteType, quantity: beatsPerMinuteQuantity, start: Date(), end: Date())
        
        // STEP 8.5: "Saves an array of objects to the HealthKit store."
        healthKitDataStore?.save([heartRateSampleData]) { (success: Bool, error: Error?) in
            // print("Heart rate \(heartRate) saved.")
            //  }
            
        } // end func writeHeartRateData
    }
        // STEP 9.0: this is my wrapper for reading all "recent"
        // heart rate samples from the HKHealthStore
        @available(iOS 13.0, *)
        func readHeartRateData() {
            // STEP 9.1: just as in STEP 6, we're telling the `HealthKitStore`
            // that we're interested in reading heart rate data
            let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
            
            // STEP 9.2: define a query for "recent" heart rate data;
            // in pseudo-SQL, this would look like:
            //
            // SELECT bpm FROM HealthKitStore WHERE qtyTypeID = '.heartRate';
            let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) {
                (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
                if let samples = samplesOrNil {
                    for heartRateSamples in samples {
                        if heartRateSamples is HKQuantitySample
                        {
                            let value: HKQuantitySample? = heartRateSamples as! HKQuantitySample
                            let hrUnit = HKUnit(from: "count/min")
                            let heartValue = (value?.quantity.doubleValue(for: hrUnit))!
                            heartBeatNums.append(Int(heartValue))
                            self.writeHeartRateData(heartRate: Int(heartValue))
                            print(Int(heartValue))
                            print(heartRateSamples.startDate)
                            self.count+=1
                            if(self.count>=self.tot){ break }
                            //print(Int(heartValue))
                        }
                    }
                    
                } else {
                    print("No heart rate sample available.")
                }
                
            }
            
            // STEP 9.3: execute the query for heart rate data
           healthKitDataStore?.execute(query)
        } // end func readHeartRateData
        
    } // end class HealthKitInterface
    

