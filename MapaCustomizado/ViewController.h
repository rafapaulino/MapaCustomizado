//
//  ViewController.h
//  MapaCustomizado
//
//  Created by Rafael Brigagão Paulino on 01/10/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapa;

-(IBAction)adicionarCirculo:(id)sender;
-(IBAction)adicionarPoligono:(id)sender;
-(IBAction)adicionarLinha:(id)sender;
-(IBAction)adicionarPino:(id)sender;
-(IBAction)ativarDesativarDesenho:(id)sender;


@end
