Class {
	#name : #PrfMethodIntercepter7,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter7 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter7 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter7 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter7 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy7 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter7 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter7 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter7 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter7 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter7 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter7 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
