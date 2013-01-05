//
//  ViewController.m
//  MapaCustomizado
//
//  Created by Rafael Brigagão Paulino on 01/10/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGPoint pontoAtual, pontoAnterior;
}

-(void)cliqueNoBotaoAcessorio;
-(void)desenharLinhaComPontoUm:(CLLocationCoordinate2D)pontoUm eComPontoDois:(CLLocationCoordinate2D)pontoDois;

@end

@implementation ViewController
@synthesize mapa;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    mapa.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapa:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(IBAction)adicionarCirculo:(id)sender
{
    MKCircle *circulo = [MKCircle circleWithCenterCoordinate:mapa.centerCoordinate radius:20000 * mapa.region.span.latitudeDelta];
    
    [mapa addOverlay:circulo];
}

-(IBAction)adicionarPoligono:(id)sender
{
    CLLocationCoordinate2D coordPoLigono[3];
    
    coordPoLigono[0] = [mapa convertPoint:CGPointMake(10,10) toCoordinateFromView:mapa];
    coordPoLigono[1] = [mapa convertPoint:CGPointMake(110,10) toCoordinateFromView:mapa];
    coordPoLigono[2] = [mapa convertPoint:CGPointMake(10,110) toCoordinateFromView:mapa];

    MKPolygon *poligono = [MKPolygon polygonWithCoordinates:coordPoLigono count:3];
    
    [mapa addOverlay:poligono];
}

-(IBAction)adicionarLinha:(id)sender
{
    [self desenharLinhaComPontoUm:[mapa convertPoint:CGPointMake(300, 10) toCoordinateFromView:mapa] eComPontoDois:[mapa convertPoint:CGPointMake(300, 210) toCoordinateFromView:mapa]];
}

-(IBAction)adicionarPino:(id)sender
{
    MKPointAnnotation *pino = [[MKPointAnnotation alloc] init];
    
    pino.coordinate = mapa.centerCoordinate;
    
    pino.title = @"Pino Customizado";
    
    [mapa addAnnotation:pino];
}

-(IBAction)ativarDesativarDesenho:(id)sender
{
    mapa.userInteractionEnabled = !mapa.userInteractionEnabled;
    
    if (mapa.userInteractionEnabled)
    {
        [sender setTitle:@"Desenhar"];
    }
    else
    {
        [sender setTitle:@"Parar"];
    }
}


//metodo acionado sempre quando um annotation é adicionado no mapa com o intuito de nos perguntar qual view desejamos carregar para o pino
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *pinoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    
    pinoView.image = [UIImage imageNamed:@"pin.png"];
    
    //quando mudamos a view do pino o balao deixa de aparecer automaticamente, devemos setar isso
    pinoView.canShowCallout = YES;
    
    //temos a possibilidade de setar acessorios do lado direito e esquerdo do balao
    
    //normalmente do lado esquerdo setamos uma imagem com uma referencia do lugar
    //a altura tem que ser de 32
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    
    imgv.image = [UIImage imageNamed:@"Angelina.jpg"];
    
    pinoView.leftCalloutAccessoryView = imgv;
    
    //do lado direito normalmente colocamos um botao de detalhes para chamar uma possivel tela com mais informacoes sobre o ponto
    UIButton *botaoAcessorio = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [botaoAcessorio addTarget:self action:@selector(cliqueNoBotaoAcessorio) forControlEvents:UIControlEventTouchUpInside];
    
    pinoView.rightCalloutAccessoryView = botaoAcessorio;
    
    return pinoView;
}

-(void)cliqueNoBotaoAcessorio
{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Botao Clicado" message:@"Você clicou no botao" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alerta show];
}


//metodo acionado quando um overlay (circulo, poligono, reta) é adicionado no mapa. Diferentemente do annotation que carregava um pino default, com os overlays somos obrigamos a implementar o método abaixo para que apareca uma view 
-(MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
   //verificar qual foi o overlay adicionado
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView *circulo = [[MKCircleView alloc] initWithOverlay:overlay];
        circulo.strokeColor = [UIColor blueColor];
        circulo.fillColor = [UIColor blueColor];
        circulo.alpha = 0.3;
        circulo.lineWidth = 3;
        
        return circulo;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView *poligono = [[MKPolygonView alloc] initWithOverlay:overlay];
        poligono.strokeColor = [UIColor redColor];
        poligono.fillColor = [UIColor redColor];
        poligono.alpha = 0.3;
        poligono.lineWidth = 3;
        
        return poligono;
    }
    else if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *linha = [[MKPolylineView alloc] initWithOverlay:overlay];
        
        linha.strokeColor = [UIColor yellowColor];
        linha.lineWidth = 3;
        
        return linha;
    }
    
    return nil;
}


-(void)desenharLinhaComPontoUm:(CLLocationCoordinate2D)pontoUm eComPontoDois:(CLLocationCoordinate2D)pontoDois
{
    CLLocationCoordinate2D coordLinha[2];
    
    coordLinha[0] = pontoUm;
    coordLinha[1] = pontoDois;
    
    MKPolyline *linha = [MKPolyline polylineWithCoordinates:coordLinha count:2];
    
    [mapa addOverlay:linha]; 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *toque = [touches anyObject];
    
    //captando a localizacao do ponto que foi dado no mapa
    pontoAnterior = [toque locationInView:mapa];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *toque = [touches anyObject];
    
    pontoAtual = [toque locationInView:mapa];
    
    [self desenharLinhaComPontoUm:[mapa convertPoint:pontoAnterior toCoordinateFromView:mapa] eComPontoDois:[mapa convertPoint:pontoAtual toCoordinateFromView:mapa]];
    
    pontoAnterior = pontoAtual;
}

@end
