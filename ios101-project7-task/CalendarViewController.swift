//
//  CalendarViewController.swift
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    var tasks: [Task] = []
    private var selectedTasks: [Task] = []

    private var calendarView: FSCalendar!

    @IBOutlet private weak var calendarContainerView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Table View
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        setContentScrollView(tableView)

        // Setup FSCalendar
        calendarView = FSCalendar()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarContainerView.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendarContainerView.topAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor)
        ])

        calendarView.dataSource = self
        calendarView.delegate = self

        // Load tasks and set today's selection if needed
        tasks = Task.getTasks()
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: today)
        let todayTasks = filterTasks(for: todayComponents)

        if !todayTasks.isEmpty {
            calendarView.select(today)
            selectedTasks = todayTasks
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTasks()
    }

    private func filterTasks(for dateComponents: DateComponents) -> [Task] {
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else {
            return []
        }
        return tasks.filter { task in
            calendar.isDate(task.dueDate, equalTo: date, toGranularity: .day)
        }
    }

    private func refreshTasks() {
        tasks = Task.getTasks()
        tasks.sort { lhs, rhs in
            if lhs.isComplete && rhs.isComplete {
                return lhs.completedDate! < rhs.completedDate!
            } else if !lhs.isComplete && !rhs.isComplete {
                return lhs.createdDate < rhs.createdDate
            } else {
                return !lhs.isComplete && rhs.isComplete
            }
        }

        if let selectedDate = calendarView.selectedDate {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            selectedTasks = filterTasks(for: components)
        }

        calendarView.reloadData()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - FSCalendarDelegate & FSCalendarDataSource

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        selectedTasks = filterTasks(for: components)

        if selectedTasks.isEmpty {
            calendar.deselect(date)
        }

        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let tasksOnDate = filterTasks(for: components)
        return tasksOnDate.isEmpty ? 0 : 1
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let tasksOnDate = filterTasks(for: components)

        let hasUncompletedTask = tasksOnDate.contains { !$0.isComplete }
        return tasksOnDate.isEmpty ? nil : [hasUncompletedTask ? .systemBlue : .systemGreen]
    }
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = selectedTasks[indexPath.row]
        cell.configure(with: task) { [weak self] task in
            task.save()
            self?.refreshTasks()
        }
        return cell
    }
}

extension Array where Element: Equatable, Element: Hashable {
    mutating func removeDuplicates() {
        let set = Set(self)
        self = Array(set)
    }
}
