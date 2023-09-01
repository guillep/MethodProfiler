Class {
	#name : #PrfMethodIntercepter73,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter73 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter73 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter73 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter73 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy73 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter73 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter73 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter73 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter73 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter73 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter73 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
