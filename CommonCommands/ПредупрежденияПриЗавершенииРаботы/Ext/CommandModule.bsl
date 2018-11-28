﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметры = Новый Структура;
	
	// Внешние параметры описания результата.
	Параметры.Вставить("Отказ", Ложь);
	Параметры.Вставить("Предупреждения", СтандартныеПодсистемыКлиент.ПараметрКлиента("ПредупрежденияПриЗавершенииРаботы"));
	
	// Внешние параметры управления выполнением.
	Параметры.Вставить("ИнтерактивнаяОбработка", Неопределено); // ОписаниеОповещения.
	Параметры.Вставить("ОбработкаПродолжения",   Неопределено); // ОписаниеОповещения.
	Параметры.Вставить("НепрерывноеВыполнение", Истина);
	
	// Внутренние параметры.
	Параметры.Вставить("ОбработкаЗавершения", Новый ОписаниеОповещения(
		"ДействияПередЗавершениемРаботыСистемыОбработкаЗавершения", СтандартныеПодсистемыКлиент, Параметры));
	
	СтандартныеПодсистемыКлиент.ДействияПередЗавершениемРаботыСистемы(Параметры);
	
КонецПроцедуры

#КонецОбласти