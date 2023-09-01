Class {
	#name : #PrfMethodIntercepter4,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter4 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter4 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter4 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter4 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy4 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter4 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter4 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter4 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter4 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter4 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter4 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
