//
//  CLRMHomeworkCell.h
//  Classroom
//
//  Created by Julio Rodríguez on 24/04/14.
//
//

#import <Foundation/Foundation.h>

@class CLRMHomework;

@interface CLRMHomeworkCell : UITableViewCell

// Cell content view UI
@property (nonatomic, weak) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellCourseLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellTeacherLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellNotesLabel;
@property (nonatomic, weak) IBOutlet UILabel *cellPriorityLabel;
@property (nonatomic, weak) IBOutlet UIImageView *cellAlarmIcon;

@end
