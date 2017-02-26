<?php
require 'vendor/autoload.php';
date_default_timezone_set('Europe/Paris');

//$log = new Monolog\Logger('name');
//$log->pushHandler(new Monolog\Handler\StreamHandler('app.txt', Monolog\Logger::WARNING));
//$log->addWarning('Oh Noes.');

$app = new \Slim\Slim( array(
    'view'=> new \Slim\Views\Twig()
));

$view = $app->view();
$view->parserOptions = array(
    'debug' => true,

);
$view->parserExtensions = array(
    new \Slim\Views\TwigExtension(),
);
/*
 * Route for index NFP121
 */
$app->get('/',function()use($app){
        $app->render('index.twig');
    })->name('home');
/*
 * Route for tp 1
 */
$app->get('/tp1',function()use($app){
    $app->render('tp1.twig');
})->name('tp1');

/*
 * Route for tp 2
 */
$app->get('/tp2',function()use($app){
    $app->render('tp2.twig');
})->name('tp2');
/*
 * Route for tp 3
 */
$app->get('/tp3',function()use($app){
    $app->render('tp3.twig');
})->name('tp3');
/*
 * Route for tp 4
 */
$app->get('/tp4',function()use($app){
    $app->render('tp4.twig');
})->name('tp4');
/*
 * Route for tp 5
 */
$app->get('/tp5',function()use($app){
    $app->render('tp5.twig');
})->name('tp5');
/*
 * Route for tp 6
 */
$app->get('/tp6',function()use($app){
    $app->render('tp6.twig');
})->name('tp6');
/*
 * Route for tp 7
 */
$app->get('/tp7',function()use($app){
    $app->render('tp7.twig');
})->name('tp7');
/*
 * Route for tp 8
 */
$app->get('/tp8',function()use($app){
    $app->render('tp8.twig');
})->name('tp8');
/*
 * Route for tp_commit
 */
$app->get('/tp_commit',function()use($app){
    $app->render('tp_commit.twig');
})->name('tp_commit');
/*
 * Route for adapter
 */
$app->get('/adapter',function()use($app){
    $app->render('/patterns/adapter.twig');
})->name('/adapter');
/*
 * Route for proxy
 */
$app->get('/proxy',function()use($app){
    $app->render('patterns/proxy.twig');
})->name('/proxy');
/*
 * Route for composite
 */
$app->get('/composite',function()use($app){
    $app->render('patterns/composite.twig');
})->name('/composite');
/*
 * Route for decorator
 */
$app->get('/decorator',function()use($app){
    $app->render('patterns/decorator.twig');
})->name('/decorator');


/*
 * Route for factoryMethod
 */
$app->get('factoryMethod',function()use($app){
    $app->render('patterns/factoryMethod.twig');
})->name('factoryMethod');


/*
 * Route for singleton
 */
$app->get('singleton',function()use($app){
    $app->render('patterns/singleton.twig');
})->name('singleton');


/*
 * Route for memento
 */
$app->get('memento',function()use($app){
    $app->render('patterns/memento.twig');
})->name('memento');


/*
 * Route for observer
 */
$app->get('observer',function()use($app){
    $app->render('patterns/observer.twig');
})->name('observer');


/*
 * Route for interpreter
 */
$app->get('interpreter',function()use($app){
    $app->render('patterns/interpreter.twig');
})->name('interpreter');

/*
 * Route for templateMethod
 */
$app->get('templateMethod',function()use($app){
    $app->render('patterns/templateMethod.twig');
})->name('templateMethod');


/*
 * Route for iterator
 */
$app->get('iterator',function()use($app){
    $app->render('patterns/iterator.twig');
})->name('iterator');
/*
 * Route for visitor
 */
$app->get('visitor',function()use($app){
    $app->render('patterns/visitor.twig');
})->name('visitor');







$app->run();



?>