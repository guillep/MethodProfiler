Class {
	#name : #PrfMethodIntercepter72,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter72 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter72 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter72 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter72 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy72 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter72 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter72 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter72 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter72 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter72 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter72 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
