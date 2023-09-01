Class {
	#name : #PrfSpecializedMethodIntercepter,
	#superclass : #MpHandler,
	#instVars : [
		'method',
		'proxy',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #creation }
PrfSpecializedMethodIntercepter class >> newForMethod: aMethod withRunner: aRunner [

	^ self new
		  method: aMethod;
		  runner: aRunner;
		  yourself
]

{ #category : #evaluating }
PrfSpecializedMethodIntercepter >> afterMethod [

	runner exitMethod: method
]

{ #category : #evaluating }
PrfSpecializedMethodIntercepter >> beforeMethod [

	runner enterMethod: method
]

{ #category : #installation }
PrfSpecializedMethodIntercepter >> install [

	proxy ifNil: [
		proxy := MpMethodProxyPrototypeFactory proxyMethod: method handler: self.
		proxy install ]
]

{ #category : #accessing }
PrfSpecializedMethodIntercepter >> method [

	^ method
]

{ #category : #accessing }
PrfSpecializedMethodIntercepter >> method: anObject [

	method := anObject
]

{ #category : #accessing }
PrfSpecializedMethodIntercepter >> proxy [

	^ proxy
]

{ #category : #accessing }
PrfSpecializedMethodIntercepter >> runner [

	^ runner
]

{ #category : #accessing }
PrfSpecializedMethodIntercepter >> runner: anObject [

	runner := anObject
]

{ #category : #installation }
PrfSpecializedMethodIntercepter >> uninstall [
	proxy ifNotNil: [ 
		proxy uninstall.
		proxy := nil ]
]
