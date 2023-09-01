Class {
	#name : #PrfMethodIntercepter2,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter2 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter2 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter2 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter2 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy2 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter2 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter2 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter2 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter2 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter2 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter2 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
