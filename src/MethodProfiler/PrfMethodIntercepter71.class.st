Class {
	#name : #PrfMethodIntercepter71,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter71 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter71 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter71 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter71 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy71 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter71 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter71 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter71 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter71 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter71 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter71 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
