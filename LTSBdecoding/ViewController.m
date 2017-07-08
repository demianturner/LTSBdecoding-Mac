//
//  ViewController.m
//  LTSBdecoding
//
//  Created by Demian Turner on 07/07/2017.
//  Copyright © 2017 Demian Turner. All rights reserved.
//

#import "ViewController.h"
#import "LTSTorrent.h"

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) NSMutableArray<LTSTorrent *> *torrents;
@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.torrents = [NSMutableArray array];
    
    [self loadTorrents];
}

- (void)loadTorrents
{
    NSURL *fileURL1 = [[NSBundle mainBundle] URLForResource: @"Pokemon.Sun.and.Moon" withExtension:@"torrent"];
    LTSTorrent *torrent1 = [[LTSTorrent alloc] initWithFileURL:fileURL1];
    [self.torrents addObject:torrent1];

    NSURL *fileURL2 = [[NSBundle mainBundle] URLForResource: @"Microsoft Office for Mac 2016 v15.13.3 Multi [TechTools]-[rarbg.to]" withExtension:@"torrent"];
    LTSTorrent *torrent2 = [[LTSTorrent alloc] initWithFileURL:fileURL2];
    [self.torrents addObject:torrent2];

    NSURL *fileURL3 = [[NSBundle mainBundle] URLForResource: @"Noise Ninja for Photoshop v2 3 2 MacOSX Incl Keymaker-CORE-[rarbg.to]" withExtension:@"torrent"];
    LTSTorrent *torrent3 = [[LTSTorrent alloc] initWithFileURL:fileURL3];
    [self.torrents addObject:torrent3];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.torrents.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    if( [tableColumn.identifier isEqualToString:@"TorrentColumn"] )
    {
        cellView.textField.stringValue = ((LTSTorrent *)[self.torrents objectAtIndex:row]).filename;
    }
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *obj = (NSTableView *)notification.object;
    NSInteger row = obj.selectedRow;
    self.textView.string = ((LTSTorrent *)[self.torrents objectAtIndex:row]).description;
}

#pragma mark - Actions
- (IBAction)openDocument:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            for (NSURL *localURL in [panel URLs]) {
                LTSTorrent *torrent = [[LTSTorrent alloc] initWithFileURL:localURL];
                if (torrent) {
                    [self.torrents addObject:torrent];
                    [self.tableView reloadData];
                }
            }
        }
        
    }];
}


@end
