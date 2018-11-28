﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭлементОбщаяПроизводительность = ОценкаПроизводительностиСлужебный.ПолучитьЭлементОбщаяПроизводительностьСистемы();
	Если Объект.Ссылка = ЭлементОбщаяПроизводительность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
