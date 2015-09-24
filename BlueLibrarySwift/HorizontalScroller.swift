//
//  HorizontalScroller.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit

@objc protocol HorizontalScrollerDelegate {
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int)
    optional func initialViewIndex(scroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView {
    
    private let VIEW_PADDING = 10
    private let VIEW_DIMENSIONS = 100
    private let VIEWS_OFFSET = 100
    
    private var scroller: UIScrollView!
    var viewArray = [UIView]()
    
    // NOTE: weak is necessary to prevent a retain cycle (all properties of swift are strong by default)
    weak var delegate: HorizontalScrollerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }
    
    private func initializeScrollView() {
        // 1
        scroller = UIScrollView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        scroller.delegate = self
        addSubview(scroller)
                
        // 2
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("scrollerTapped:"))
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    func scrollerTapped(gesture: UITapGestureRecognizer) {
        
        let location = gesture.locationInView(gesture.view)
        
        if let delegate = delegate {
            for index in 0 ..< delegate.numberOfViewsForHorizontalScroller(self) {
                let view = scroller.subviews[index] as UIView
                
                if CGRectContainsPoint(view.frame, location) {
                    delegate.horizontalScrollerClickedViewAtIndex(self, index: index)
                    let pointOffset = CGPoint(x: view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2, y: 0)
                    // center the tapped view in scroller
                    scroller.setContentOffset(pointOffset, animated: true)
                    break
                }
            }
        }
    }
    
    func viewAtIndex(index: Int) -> UIView {
        return scroller.subviews[index]
    }
    
    // modeled after reloadData in UITableView
    func reload() {
        if let delegate = delegate {
            let views = scroller.subviews
            
            // swift 2.0 views.forEach?
            for view in views {
                view.removeFromSuperview()
            }
            
            // xValue is the starting point of the views inside the scroller
            var xValue = VIEWS_OFFSET
            for index in 0 ..< delegate.numberOfViewsForHorizontalScroller(self) {
                // add view at the right position
                xValue += VIEW_PADDING
                
                let view = delegate.horizontalScrollerViewAtIndex(self, index: index)
                view.frame = CGRectMake(xValue.cgFloatValue,
                    VIEW_PADDING.cgFloatValue,
                    VIEW_DIMENSIONS.cgFloatValue,
                    VIEW_DIMENSIONS.cgFloatValue)
                xValue += VIEW_DIMENSIONS + VIEW_PADDING
                
                scroller.addSubview(view)
            }
            
            scroller.contentSize = CGSizeMake((xValue + VIEWS_OFFSET).cgFloatValue, frame.size.height)
            
            // If an initial view is defined center the scroller on it
            if let initialView = delegate.initialViewIndex?(self) {
                let point = CGPoint(x: initialView * VIEW_DIMENSIONS + 2 * VIEW_PADDING, y: 0)
                scroller.setContentOffset(point, animated: true)
            }
        }
    }
    
    private func centerCurrentView() {
        let xFinal = Int(scroller.contentOffset.x) + VIEWS_OFFSET / 2 + VIEW_PADDING
        let viewIndex = xFinal / (VIEW_DIMENSIONS + 2 * VIEW_PADDING)
        scroller.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        
        if let delegate = delegate {
            delegate.horizontalScrollerViewAtIndex(self, index: viewIndex)
        }
    }
    
    override func didMoveToSuperview() {
        reload()
    }
}

extension HorizontalScroller: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerCurrentView()
    }
}