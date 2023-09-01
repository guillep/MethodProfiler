Class {
	#name : #PrfMethodIntercepter6,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter6 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter6 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter6 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter6 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy6 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter6 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter6 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter6 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter6 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter6 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter6 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
