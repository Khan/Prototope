var layer = new Layer({parent: Layer.root});
Layer.animate({duration: 3.0, curve: AnimationCurve.EaseOut, animations: function() { layer.x = 400 }});
var pinch = new PinchGesture({handler: function(phase, sequence) {console.log('pinch:'+sequence.currentSample.scale)}});
var pan = new PanGesture({handler: function(phase, sequence) {
                         var loc = sequence.currentSample.globalLocation;
                         console.log('pan:'+loc.x+','+loc.y)
                         }});
var simul = function(gesture) { return true; };
pinch.shouldRecognizeSimultaneouslyWithGesture = simul
pan.shouldRecognizeSimultaneouslyWithGesture = simul
layer.gestures = [
                  pinch,
                  pan
                  ];
layer.backgroundColor = new Color({red: 0.5, green: 0.7, blue: 0.1, alpha: 0.7});
layer.frame = new Rect({x: 75, y: 80, width: 400, height: 400});
layer.border = new Border({color: Color.black, width: 2});
layer.shadow = new Shadow({alpha: 1.0});
(new Sound({name: 'Glass'})).play()

var video = new Video({name: "countdown.mp4"});
var videoLayer = new VideoLayer({parent: Layer.root, video: video });
videoLayer.play();

var particle = new Particle({imageName: "paint"})
particle.spin = 2;

var emitter = new ParticleEmitter({particle: particle});
layer.addParticleEmitter(emitter);
layer.removeParticleEmitter(emitter);