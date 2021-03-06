//
//  JFTWeekView.swift
//  CalendarCloneTakeTwo
//
//  Created by hyperactive hi-tech ltd on 18/05/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable
class JFTWeekView: UIView, UIScrollViewDelegate
{
    private var infiniteScrollHandler: JFTInfiniteScrollViewPresentationHandler?
    private static let xibName: String = "JFTWeekView"
    private static let formatter: DateFormatter = DateFormatter()
    private var finishedLoading: Bool = false
    @IBOutlet var view: UIView!
    @IBOutlet weak var WeekLayoutScrollView: UIScrollView!
    @IBOutlet weak var SelectedDateLable: UILabel!


    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(JFTWeekView.xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        JFTWeekView.formatter.dateFormat = "EEEE dd MMM, yyyy"
        SelectedDateLable.text = JFTWeekView.formatter.string(from: Date())
        WeekLayoutScrollView.delegate = self
        WeekLayoutScrollView.isPagingEnabled = true
        infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: WeekLayoutScrollView, type: .JFTWeekViewType)
        finishedLoading = true
    }
    
    
    // MARK: Scroll View Events
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if scrollView.isDragging
        {
            if translation.x > 0
            {
                infiniteScrollHandler!.OnScrollLeft()
            }
            else if translation.x < 0
            {
                infiniteScrollHandler!.OnScrollRight()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        if finishedLoading
        {
            infiniteScrollHandler!.OnFinishedScrollingForWeekView()
        }
    }
    
    
    // MARK: Caller Events
    func OnNewSelectedDay()
    {
        
        SelectedDateLable.text = JFTWeekView.formatter.string(from: (JFTDayViewController.CurrentReference!.selectedDay.GetDate()))
    }
    
    func LoadWithSelectedDate(selected date: Date)
    {
        infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: WeekLayoutScrollView, type: .JFTWeekViewType, selected: date)
        JFTWeekLayoutView.SetWeekdayForDate(date: date)
        let firstViewReference = WeekLayoutScrollView.subviews[0] as! JFTWeekLayoutView
        firstViewReference.HighlightSelectedDay()
    }
    
    func OnSetTodayTouch()
    {
        if infiniteScrollHandler!.IsSelectedDayToday()
        {
            if !infiniteScrollHandler!.IsScrollViewCentered()
            {
                infiniteScrollHandler!.OnMoveToTodayRequest()
                OnNewSelectedDay()
                let firstViewReference = WeekLayoutScrollView.subviews[0] as! JFTWeekLayoutView
                firstViewReference.SetWeekdayForToday()
                firstViewReference.HighlightSelectedDay()
                JFTDayViewController.CurrentReference!.SelectDay(selected: JFTDay(date: Date()))
            }
            else if !(JFTDayViewController.CurrentReference!.selectedDay == JFTDay(date: Date()))
            {
                infiniteScrollHandler!.OnMoveToTodayRequest()
                OnNewSelectedDay()
                let firstViewReference = WeekLayoutScrollView.subviews[0] as! JFTWeekLayoutView
                firstViewReference.SetWeekdayForToday()
                firstViewReference.HighlightSelectedDay()
                JFTDayViewController.CurrentReference!.SelectDay(selected: JFTDay(date: Date()))
            }
            
        }
        else
        {
            infiniteScrollHandler = JFTInfiniteScrollViewPresentationHandler(scrollViewToReference: WeekLayoutScrollView, type: .JFTWeekViewType)
            self.view.setNeedsDisplay()
            OnSetTodayTouch()
        }
    }
}
