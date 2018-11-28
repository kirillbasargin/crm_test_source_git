﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Элементы.СтраницыДеятельностьПрекращена.Видимость = Объект.ДеятельностьПрекращена Или Пользователи.ЭтоПолноправныйПользователь();
	Элементы.СтраницыДеятельностьПрекращена.ТекущаяСтраница = ?(Пользователи.ЭтоПолноправныйПользователь(),
		Элементы.СтраницаФлажокДеятельностьПрекращена, Элементы.СтраницаНадписьДеятельностьПрекращена);
		
	Если Объект.ДеятельностьПрекращена Тогда
		КлючСохраненияПоложенияОкна = "ДеятельностьПрекращена";
		Элементы.НадписьДеятельностьБанкаПрекращена.Заголовок = РаботаСБанками.ПояснениеНедействительногоБанка(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		
		МодульАвтономнаяРабота = ОбщегоНазначения.ОбщийМодуль("АвтономнаяРабота");
		МодульАвтономнаяРабота.ОбъектПриЧтенииНаСервере(ТекущийОбъект, ЭтотОбъект.ТолькоПросмотр);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
