Class {
	#name : #PrfMethodIntercepter5,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfMethodIntercepter5 class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfMethodIntercepter5 >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfMethodIntercepter5 >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfMethodIntercepter5 >> install [

	proxy ifNil: [
		proxy := MpMethodProxy5 onMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfMethodIntercepter5 >> method [

	^ method
]

{ #category : #accessing }
PrfMethodIntercepter5 >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfMethodIntercepter5 >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfMethodIntercepter5 >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodIntercepter5 >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfMethodIntercepter5 >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
