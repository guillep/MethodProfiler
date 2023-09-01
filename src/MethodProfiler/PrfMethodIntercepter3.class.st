Class {
	#name : #PrfMethodIntercepter3,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter3 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter3 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter3 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter3 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy3 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter3 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter3 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter3 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter3 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter3 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter3 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
