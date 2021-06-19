//
//  CalendarViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/9/20.
//

import UIKit
import CalendarKit
import Foundation
import FirebaseDatabase


class CalendarViewController: DayViewController {

    var data = [["Sorry",
                 "I'm bad at coding this shouldn't be here"],
    ]
    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()

    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]

    private lazy var rangeFormatter: DateIntervalFormatter = {
      let fmt = DateIntervalFormatter()
      fmt.dateStyle = .none
      fmt.timeStyle = .short

      return fmt
    }()

    override func loadView() {
      calendar.timeZone = TimeZone(identifier: "America/New_York")!

      dayView = DayView(calendar: calendar)
      view = dayView
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      title = "Calendar"
      navigationController?.navigationBar.isTranslucent = false
      dayView.autoScrollToFirstEvent = true
      reloadData()
    }
    
    // MARK: EventDataSource
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
      if !alreadyGeneratedSet.contains(date) {
        alreadyGeneratedSet.insert(date)
        generatedEvents.append(contentsOf: generateEventsForDate(date))
      }
      return generatedEvents
    }
    
    
    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"

        print(dateFormatter.string(from: date))
        let formattedDate = dateFormatter.string(from: date)
        var events = [Event]()

        
        
        let ref = Database.database().reference()
        ref.child("calendar").child(dateFormatter.string(from: date)).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Lalalala")
            let value = snapshot.value as? NSArray
            let event = Event()
            for ev in value!{
                let eventDict = ev as! Dictionary<String, Any>
                
                var dateComponents1 = DateComponents()
                var dateComponents2 = DateComponents()
                dateComponents1.year = Int(formattedDate.components(separatedBy: "-")[2])
                dateComponents1.month = Int(formattedDate.components(separatedBy: "-")[0])
                dateComponents1.day = Int(formattedDate.components(separatedBy: "-")[1])
                dateComponents2.year = Int(formattedDate.components(separatedBy: "-")[2])
                dateComponents2.month = Int(formattedDate.components(separatedBy: "-")[0])
                dateComponents2.day = Int(formattedDate.components(separatedBy: "-")[1])
                dateComponents1.hour = Int((eventDict["startTime"] as? String)!.components(separatedBy: "-")[0])
                dateComponents1.minute = Int((eventDict["startTime"] as? String)!.components(separatedBy: "-")[1])
                dateComponents2.hour = Int((eventDict["endTime"] as? String)!.components(separatedBy: "-")[0])
                dateComponents2.minute = Int((eventDict["endTime"] as? String)!.components(separatedBy: "-")[1])
                let userCalendar = Calendar.current // user calendar
                event.startDate =  userCalendar.date(from: dateComponents1)!
                event.text = (eventDict["text"] as? String)!
                event.isAllDay = false
                event.endDate =  userCalendar.date(from: dateComponents2)!
                print("hihihihi")
                print(event)
                events.append(event)
                print(events)
            }
            
            
            
        }) { (error) in
          print(error.localizedDescription)
      }
        return events

//        print("hi?")
//        print(self.events)
//        return self.events
//        let event = Event()
//
//        var dateComponents1 = DateComponents()
//        dateComponents1.year = 2021
//        dateComponents1.month = 6
//        dateComponents1.day = 19
//        dateComponents1.timeZone = TimeZone(abbreviation: "EST") // Japan Standard Time
//        dateComponents1.hour = 8
//        dateComponents1.minute = 34
//
//        var dateComponents2 = DateComponents()
//        dateComponents2.year = 2021
//        dateComponents2.month = 6
//        dateComponents2.day = 19
//        dateComponents2.timeZone = TimeZone(abbreviation: "EST") // Japan Standard Time
//        dateComponents2.hour = 9
//        dateComponents2.minute = 34
//
//        // Create date from components
//        let userCalendar = Calendar.current // user calendar
//        event.startDate =  userCalendar.date(from: dateComponents1)!
//        event.text = "Test Event"
//        event.isAllDay = false
//        event.endDate =  userCalendar.date(from: dateComponents2)!
//        // set event.color based on person who created it! don't know how colors work lol
////            print(events[0].backgroundColor)
////            print(events[0].color)
////            print(events[0].textColor)
//
//        events.append(event)
//        print(events)
//        return events
//        return events
//      var workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
//      var events = [Event]()
//
//      for i in 0...4 {
//        let event = Event()
//
//        let duration = Int.random(in: 60 ... 160)
//        event.startDate = workingDate
//        event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: workingDate)!
//
//        var info = data[Int(arc4random_uniform(UInt32(data.count)))]
//
//        let timezone = dayView.calendar.timeZone
//        print(timezone)
//
//        info.append(rangeFormatter.string(from: event.startDate, to: event.endDate))
//        event.text = info.reduce("", {$0 + $1 + "\n"})
//        event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
//        event.isAllDay = Int(arc4random_uniform(2)) % 2 == 0
//
//        // Event styles are updated independently from CalendarStyle
//        // hence the need to specify exact colors in case of Dark style
//        if #available(iOS 12.0, *) {
//          if traitCollection.userInterfaceStyle == .dark {
//            event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
//            event.backgroundColor = event.color.withAlphaComponent(0.6)
//          }
//        }
//
//        events.append(event)
//
//        let nextOffset = Int.random(in: 40 ... 250)
//        workingDate = Calendar.current.date(byAdding: .minute, value: nextOffset, to: workingDate)!
//        event.userInfo = String(i)
//      }
//
//      print("Events for \(date)")
//      return events
    }
    
    private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
      var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
      return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
    }
    
    // MARK: DayViewDelegate
    
    private var createdEvent: EventDescriptor?
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
      guard let descriptor = eventView.descriptor as? Event else {
        return
      }
      print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
      guard let descriptor = eventView.descriptor as? Event else {
        return
      }
      endEventEditing()
      print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
      beginEditing(event: descriptor, animated: true)
      print(Date())
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
      endEventEditing()
      print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
      endEventEditing()
      print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
      print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
      print("DayView = \(dayView) did move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
      print("Did long press timeline at date \(date)")
      // Cancel editing current event and start creating a new one
      endEventEditing()
      let event = generateEventNearDate(date)
      print("Creating a new event")
      create(event: event, animated: true)
      createdEvent = event
    }
    
    private func generateEventNearDate(_ date: Date) -> EventDescriptor {
      let duration = Int(arc4random_uniform(160) + 60)
      let startDate = Calendar.current.date(byAdding: .minute, value: -Int(CGFloat(duration) / 2), to: date)!
      let event = Event()

      event.startDate = startDate
      event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: startDate)!

      var info = data[Int(arc4random_uniform(UInt32(data.count)))]

      info.append(rangeFormatter.string(from: event.startDate, to: event.endDate))
      event.text = info.reduce("", {$0 + $1 + "\n"})
      event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
      event.editedEvent = event

      // Event styles are updated independently from CalendarStyle
      // hence the need to specify exact colors in case of Dark style
      if #available(iOS 12.0, *) {
        if traitCollection.userInterfaceStyle == .dark {
          event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
          event.backgroundColor = event.color.withAlphaComponent(0.6)
        }
      }
      return event
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
      print("did finish editing \(event)")
      print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
      
      if let _ = event.editedEvent {
        event.commitEditing()
      }
      
      if let createdEvent = createdEvent {
        createdEvent.editedEvent = nil
        generatedEvents.append(createdEvent)
        self.createdEvent = nil
        endEventEditing()
      }
      
      reloadData()
    }

}

