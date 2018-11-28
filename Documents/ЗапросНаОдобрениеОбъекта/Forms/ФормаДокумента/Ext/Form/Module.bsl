﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;	
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Черновик = Истина;
		Объект.Ответственный = Пользователи.ТекущийПользователь();
		//СтатусЗаявки = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.Новая;
	КонецЕсли;		
	
	ПолеПоиска = ?(ЗначениеЗаполнено(Объект.ФИОКлиента), Объект.ФИОКлиента, "");
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеЗаявкиПриИзменении(Элемент)
	УправлениеВидимостьюДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура СтатусЗаявкиПриИзменении(Элемент)
	
	Если Объект.СтатусЗаявки = ПредопределенноеЗначение("Справочник.СтатусыЗаявокНаОдобрениеОбъекта.ВозвратНаДоработку") ИЛИ 
		Объект.СтатусЗаявки = ПредопределенноеЗначение("Справочник.СтатусыЗаявокНаОдобрениеОбъекта.ПустаяСсылка") Тогда
		Объект.УспешнаяОтправка = Ложь;
	Иначе
		Объект.УспешнаяОтправка = Истина;
	КонецЕсли;
	УправлениеВидимостьюДоступностью();
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаМенеджеру", ЭтаФорма);
	ПоказатьВопрос(Оповещение, "Отправить оповещение менеджеру?", РежимДиалогаВопрос.ДаНет, 0); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("transactId") Тогда
		ЭлементСписка = СписокВыбораПоиска.НайтиПоЗначению(ВыбранноеЗначение.transactId);
		Для каждого ЭлементСписка Из СписокВыбораПоиска Цикл 
			Если ЭлементСписка.Значение.transactId = ВыбранноеЗначение.transactId Тогда
				ПолеПоиска = ЭлементСписка.Представление;
				ЗаполнитьПоРезультатамПоиска(ЭлементСписка.Значение);
				Модифицированность = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РекомендуемыйБанкПриИзменении(Элемент)
	РекомендуемыйБанкПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомментарииЗаявкиПрикрепленныеФайлы

&НаКлиенте
Процедура КомментарииЗаявкиКомментарийОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.КомментарииЗаявки.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда		
		Подсказка = "Введите текст комментария";
		Оповещение = Новый ОписаниеОповещения("ПослеВводаСтрокиКомментария", ЭтотОбъект, Параметры);
		ПоказатьВводСтроки(Оповещение, ТекущиеДанные.Комментарий, "Введите текст комментария", 0, Истина);
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура КомментарииЗаявкиКомментарийПриИзменении(Элемент)

	ТекущиеДанные = Элементы.КомментарииЗаявки.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда	
		Комментарий = ТекущиеДанные.Комментарий;
		ТекущиеДанные.ДатаДобавления = ТекущаяДата();
		ТекущиеДанные.Отправлять = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеФайлыПередУдалением(Элемент, Отказ)
	//Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарииЗаявкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявкуOnLine(Команда)

	Если Модифицированность Тогда	
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОЗаписи", ЭтаФорма, Новый Структура("CallBack", Новый ОписаниеОповещения("ВыполнитьОтправку_Асинхр", ЭтаФорма)));
		ПоказатьВопрос(Оповещение, "Для продолжения необходимо записать запрос. Продолжить?", РежимДиалогаВопрос.ДаНет, 0); 
	Иначе
		ОтправитьЗапросаНаОдобрение();	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФайлы(Команда)
	ОбновитьТаблицуФайлов();
КонецПроцедуры

&НаКлиенте
Процедура кнДобавитьФайл(Команда)
		
	Если Объект.Ссылка.Пустая() Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОЗаписи", ЭтаФорма, Новый Структура("CallBack", Новый ОписаниеОповещения("ДобавитьФайлы_Асинхр", ЭтаФорма)));
		ПоказатьВопрос(Оповещение, "Для продолжения необходимо записать запрос на одобрение. Продолжить?", РежимДиалогаВопрос.ДаНет, 0); 
	Иначе
		ДобавитьФайлы_Асинхр(Истина, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура кнОткрытьКарточкуФайла(Команда)
	
	ТекДанные = Элементы.ПрикрепленныеФайлы.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		ОткрытьЗначение(Элементы.ПрикрепленныеФайлы.ТекущиеДанные.Файл);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура кнУдалитьФайл(Команда)
	
	ТекДанные = Элементы.ПрикрепленныеФайлы.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		Попытка
			УдалитьФайлНаСервере(ТекДанные.Файл);
			Объект.ПрикрепленныеФайлы.Удалить(ТекДанные);
			ЭтаФорма.Модифицированность = Истина;	
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось удалить файл: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура кнПросмотрФайла(Команда)
	
	ТекДанные = Элементы.ПрикрепленныеФайлы.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(Элементы.ПрикрепленныеФайлы.ТекущиеДанные.Файл, ЭтаФорма.УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Авторизация(Команда)
	
	Ошибки = "";	
	Авторизация = ЗаявкиНаКредитRestAPI.ВыполнитьАвторизацию(Объект.ПараметрыПодключения, TGT, ST, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
	Если Ошибки = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("X_Auth_Token = " + Token);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("X_Auth_User = " + X_Auth_User);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при авторизации: " + Ошибки);			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Разлогиниться(Команда)
	
	Ошибки = "";	
	Авторизация = ЗаявкиНаКредитRestAPI.Разлогиниться(Объект.ПараметрыПодключения, Объект.ТестоваяЗаявка, Ошибки);
	Если НЕ Ошибки = "" Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при авторизации: " + Ошибки);			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДокуметнты(Команда)
	
	Если ЗначениеЗаполнено(Объект.ID_Заявки) Тогда		
		Для каждого СтрокаФайл Из Объект.ПрикрепленныеФайлы Цикл
			Если НЕ СтрокаФайл.Отправлять Тогда
				Продолжить;
			КонецЕсли;			
			Ошибки = "";	
			Данные = ЗаявкиНаКредитRestAPI.ДобавитьФайлКЗапросуНаОдобрение(Объект.ПараметрыПодключения, Объект.ID_Заявки, СтрокаФайл.Файл, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
			Если Ошибки = "" Тогда
				Если ТипЗнч(Данные) = Тип("Структура") Тогда
					ЗаполнитьЗначенияСвойств(СтрокаФайл, Данные);
					Если НЕ ЗначениеЗаполнено(СтрокаФайл.create_date) Тогда
						СтрокаФайл.create_date = ТекущаяДата();	
					КонецЕсли;					
					СтрокаФайл.Отправлять = Ложь;
					Модифицированность = Истина;
				КонецЕсли;	
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при отправке вложения: " + Ошибки);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заявка не отправлена");		
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарии(Команда)
	
	Если ЗначениеЗаполнено(Объект.ID_Заявки) Тогда		
		Для каждого СтрокаКомментарий Из Объект.КомментарииЗаявки Цикл
			Если НЕ СтрокаКомментарий.Отправлять Тогда
				Продолжить;
			КонецЕсли;							
			Ошибки = "";
			ID_Комментария = ЗаявкиНаКредитRestAPI.ДобавитьКомментарийКЗапросуНаОдобрение(Объект.ПараметрыПодключения, Объект.ID_Заявки, Объект.ID_ЗаявкиНаКредит, СтрокаКомментарий.Комментарий, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
			Если Ошибки = "" Тогда
				СтрокаКомментарий.ID = ID_Комментария;
				СтрокаКомментарий.ДатаОтправки = ТекущаяДата();
				СтрокаКомментарий.Отправлять = Ложь;
				Модифицированность = Истина;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка отправке комментария: " + Ошибки);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заявка не отправлена");		
	КонецЕсли;		
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатус(Команда)
	
	//Ошибки = "";	
	//ИдентификаторЗаявкиНаКредит = ЗаявкиНаКредитRestAPI.ИзменитьСтатусЗаявки(Объект.ПараметрыПодключения, Объект.СтатусЗаявки, Объект.ID_Заявки, Объект.КомментарийСтатуса, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
	//Если Ошибки = "" Тогда
	//	Если Объект.ID_Заявки = ИдентификаторЗаявкиНаКредит И ЗначениеЗаполнено(ИдентификаторЗаявкиНаКредит) Тогда
	//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Статус обновлен на " + Объект.СтатусЗаявки);				
	//		Модифицированность = Истина;
	//	КонецЕсли;
	//Иначе
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка обновления статуса заявки: " + Ошибки);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеОЗаявке(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВопросВыводитьХодОбновления", ЭтаФорма, Новый Структура("CallBack", Новый ОписаниеОповещения("ПолучитьДанныеОЗапросе_Асинхр", ЭтаФорма)));
	ПоказатьВопрос(Оповещение, "Выводить сообщения о результатах обновления?", РежимДиалогаВопрос.ДаНет, 0);
			
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеАгенты(Команда)

	Ошибки = "";	
	ДанныеОбАгентах = ЗаявкиНаКредитRestAPI.ПолучитьДоступныхАгентов(Объект.ПараметрыПодключения, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
	Если Ошибки = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Данные об агентах: ");
		Для каждого Данные Из ДанныеОбАгентах Цикл
			Для каждого Элемент Из Данные Цикл
				Если ТипЗнч(Элемент.Значение) = Тип("Строка")
					ИЛИ ТипЗнч(Элемент.Значение) = Тип("Число")
					ИЛИ Элемент.Значение = Неопределено Тогда
					Сообщить(Элемент.Ключ + " : " + ?(ТипЗнч(Элемент.Значение) = Тип("Число"), СтрЗаменить(Элемент.Значение, Символы.НПП, ""), Элемент.Значение));		
				КонецЕсли;
			КонецЦикла;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("");
		КонецЦикла;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при получении данных об агентах: " + Ошибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьФайл(Команда)
	
	Ошибки = "";	
	ТекущиеДанные = Элементы.ПрикрепленныеФайлы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.Path = "" Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = ТекущиеДанные.Path;
	
	ДанныеФайла = ЗаявкиНаКредитRestAPI.ПолучитьДанныеФайла(Объект.ПараметрыПодключения, ПутьКФайлу, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки, ЭтаФорма.УникальныйИдентификатор);
	Если Ошибки = "" Тогда
		Если ЭтоАдресВременногоХранилища(ДанныеФайла.Адрес) Тогда
			#Если ВебКлиент Тогда
				ОписаниеПередаваемогоФайла = Новый ОписаниеПередаваемогоФайла(ДанныеФайла.ИмяФайла, ДанныеФайла.Адрес); //ПолучитьИмяВременногоФайла(ДанныеФайла.Расширение)
				ПолучаемыеФайлы = Новый Массив;
				ПолучаемыеФайлы.Добавить(ОписаниеПередаваемогоФайла);

				ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
				ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
				ДиалогОткрытияФайла.Расширение = ДанныеФайла.Расширение;
				ДиалогОткрытияФайла.ПолноеИмяФайла = ДанныеФайла.ИмяФайла;
				ДиалогОткрытияФайла.ПредварительныйПросмотр = Истина;
				
				ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаСохраненияФайлов", ЭтаФорма);
				НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы,  ДиалогОткрытияФайла,  Истина);
			#Иначе
				ПолучитьФайл(ДанныеФайла.Адрес, ДанныеФайла.ИмяФайла, Истина);				
			#КонецЕсли
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при получении файла: " + Ошибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОтделенияБанков(Команда)

	Данные = ЗаявкиНаКредитRestAPI.ПолучитьОтделенияБанков();
	Для каждого Элемент Из Данные Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("ID = " + Элемент.ID + ";" + "full_address = " + Элемент.full_address + ";" + "name = " + Элемент.name);	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Отказ(Команда)	
	
	Если ЗначениеЗаполнено(Объект.ID_Заявки) Тогда		
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ОписаниеОповещенияОЗавершенииВводаКомментарияОтказа", ЭтаФорма);
		ПоказатьВводСтроки(ОписаниеОповещенияОЗавершении, Объект.КомментарийСтатуса, "Введите комментарий отказа", ,Истина); 
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заявка не отправлена");		
	КонецЕсли;		
		
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНастройкуПользователя(Команда)
	
	Попытка
		ЗаявкиНаКредитRestAPI.ПолучитьПараметрыПодключения(Объект.ПараметрыПодключения, Объект.Ответственный, Истина);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ВыполнитьПоискНаСервере();	
	Если СписокВыбораПоиска.Количество() = 1 Тогда	
		ПолеПоиска = СписокВыбораПоиска[0].Представление;
		ЗаполнитьПоРезультатамПоиска(СписокВыбораПоиска[0].Значение);
	ИначеЕсли СписокВыбораПоиска.Количество() > 1  Тогда
		Оп = Новый ОписаниеОповещения("ВыполнитьПослеВыбора", ЭтотОбъект);  //, ПолеПоиска, Параметр
		ПоказатьВыборИзСписка(Оп, СписокВыбораПоиска, Элементы.ПолеПоиска);	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокЗапросовНаОдобрение(Команда)
	
	Ошибки = "";	
	СписокЗапросов = ЗаявкиНаКредитRestAPI.ПолучитьСписокЗапросовНаОдобрение(Объект.ПараметрыПодключения, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
	Если Ошибки = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Список запросов: ");
		Для каждого Данные Из СписокЗапросов Цикл
			Для каждого Элемент Из Данные Цикл
				Если ТипЗнч(Элемент.Значение) = Тип("Строка")
					ИЛИ ТипЗнч(Элемент.Значение) = Тип("Число")
					ИЛИ Элемент.Значение = Неопределено Тогда
					Сообщить(Элемент.Ключ + " : " + ?(ТипЗнч(Элемент.Значение) = Тип("Число"), СтрЗаменить(Элемент.Значение, Символы.НПП, ""), Элемент.Значение));		
				КонецЕсли;
			КонецЦикла;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("");
		КонецЦикла;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при получении списка запросов: " + Ошибки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура кнДобавитьСтрокиКомментария(Команда)
	
	ТекущиеДанные = Объект.КомментарииЗаявки.Добавить();
	Если НЕ ТекущиеДанные = Неопределено Тогда	
		Комментарий = "Добрый день! Направляю запрос на одобрение.";
		ТекущиеДанные.Комментарий = Комментарий;
		ТекущиеДанные.ДатаДобавления = ТекущаяДата();
		ТекущиеДанные.Отправлять = Истина;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтправитьЗапросаНаОдобрение()
	
	Отказ = Ложь;
	ПроверитьПередОтправкой(Отказ);
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
		
	Ошибки = "";
	Если НЕ ЗначениеЗаполнено(Объект.ID_Заявки) Тогда
		ID_Заявки = ЗаявкиНаКредитRestAPI.ОтправитьЗапросНаОдобрение(Объект.ПараметрыПодключения, Объект.transactID, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
		Если Ошибки = "" Тогда
			Объект.ID_Заявки = ID_Заявки;
			Объект.ДатаПодачиЗаявки = ТекущаяДата();
			Модифицированность = Истина;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при отправке заявки " + ID_Заявки + ": " + Ошибки);
			Возврат;
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрос создан");
	КонецЕсли;
	
	Ошибки = "";	
	Если ЗначениеЗаполнено(Объект.ID_Заявки) Тогда		
		Для каждого СтрокаФайл Из Объект.ПрикрепленныеФайлы Цикл
			Если НЕ СтрокаФайл.Отправлять Тогда
				Продолжить;
			КонецЕсли;	
			Данные = ЗаявкиНаКредитRestAPI.ДобавитьФайлКЗапросуНаОдобрение(Объект.ПараметрыПодключения, Объект.ID_Заявки, СтрокаФайл.Файл, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
			Если Ошибки = "" Тогда
				Если ТипЗнч(Данные) = Тип("Структура") Тогда
					ЗаполнитьЗначенияСвойств(СтрокаФайл, Данные);
					Если НЕ ЗначениеЗаполнено(СтрокаФайл.create_date) Тогда
						СтрокаФайл.create_date = ТекущаяДата();	
					КонецЕсли;					
					СтрокаФайл.Отправлять = Ложь;
					Модифицированность = Истина;
				КонецЕсли;	
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при отправке прикрепленных файлов: " + Ошибки);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заявка не отправлена");
		Возврат;
	КонецЕсли;		
	
	Ошибки = "";	
	Если ЗначениеЗаполнено(Объект.ID_Заявки) Тогда		
		Для каждого СтрокаКомментарий Из Объект.КомментарииЗаявки Цикл
			Если НЕ СтрокаКомментарий.Отправлять Тогда
				Продолжить;
			КонецЕсли;			
			ID_Комментария = ЗаявкиНаКредитRestAPI.ДобавитьКомментарийКЗапросуНаОдобрение(Объект.ПараметрыПодключения, Объект.ID_Заявки, Объект.ID_ЗаявкиНаКредит, СтрокаКомментарий.Комментарий, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);				
			Если Ошибки = "" Тогда
				СтрокаКомментарий.ID = ID_Комментария;
				СтрокаКомментарий.ДатаОтправки = ТекущаяДата();
				СтрокаКомментарий.Отправлять = Ложь;
				Модифицированность = Истина;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка отправке комментариев заявки: " + Ошибки);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заявка не отправлена");	
		Возврат;
	КонецЕсли;		
	
	Ошибки = "";
	КомментарийСтатуса = "";
	Для каждого Строка Из Объект.КомментарииЗаявки Цикл
		Если ЗначениеЗаполнено(Строка.Комментарий) И НЕ Строка.Комментарий = Объект.КомментарийСтатуса Тогда			
			КомментарийСтатуса = Строка.Комментарий;			
		КонецЕсли;		
	КонецЦикла;
	Объект.КомментарийСтатуса = КомментарийСтатуса;
	Идентификатор = ЗаявкиНаКредитRestAPI.ИзменитьСтатусЗапросаНаОдобрение(Объект.ПараметрыПодключения, ПредопределенноеЗначение("Справочник.СтатусыЗаявокНаОдобрениеОбъекта.ОтправленаВБанк"), Объект.ID_Заявки, Объект.КомментарийСтатуса, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки); 
	Если Ошибки = "" Тогда
		Если ЗначениеЗаполнено(Идентификатор) И Объект.ID_Заявки = Идентификатор Тогда
			Объект.Черновик = Ложь;
			Объект.ДатаУстановкиСтатуса = ТекущаяДата();
			Объект.СтатусЗаявки = ПредопределенноеЗначение("Справочник.СтатусыЗаявокНаОдобрениеОбъекта.ОтправленаВБанк");
			Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Отправка");
			Объект.УспешнаяОтправка = Истина;
			Модифицированность = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Статус обновлен на " + Объект.СтатусЗаявки);	
		КонецЕсли;
	Иначе
		Объект.СтатусЗаявки = 0;
		Объект.УспешнаяОтправка = Ложь;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка обновления статуса заявки: " + Ошибки);
		Возврат;
	КонецЕсли;
	
	Если Ошибки = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заявка успешно отправлена.");
		Если Модифицированность Тогда
			Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение)); 
			//Если ЗначениеЗаполнено(Объект.СтатусЗаявки) Тогда
			//	РегНаб = РегистрыСведений.ИсторияСтатусовИпотечныхЗаявок.СоздатьНаборЗаписей();
			//	РегНаб.Отбор.ИпотечнаяЗаявка.Установить(Объект.Ссылка);		
			//	РегНаб.Прочитать();		
			//	Попытка				
			//		Date = ТекущаяДата();
			//		Status = Объект.СтатусЗаявки;					
			//		Если НЕ ЗаявкиНаКредитRestAPI.ЗаписьЕстьВНаборе(РегНаб, Date, Status) Тогда		
			//			НовЗапись = РегНаб.Добавить();
			//			НовЗапись.ИпотечнаяЗаявка = Объект.Ссылка;
			//			НовЗапись.Date = Date;
			//			НовЗапись.Status = Status;			
			//		КонецЕсли;
			//		Если РегНаб.Модифицированность() Тогда
			//			РегНаб.Записать(Истина);
			//		КонецЕсли;			
			//	Исключение				
			//	КонецПопытки;															
			//КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьФайлНаСервере(Файл)
	
	ФайлОбъект = Файл.ПолучитьОбъект();
	Если НЕ ФайлОбъект = Неопределено Тогда
		ФайлОбъект.УстановитьПометкуУдаления(НЕ ФайлОбъект.ПометкаУдаления);//.Удалить();
	КонецЕсли;                                      
	//ОбновитьТаблицуФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСохраненияФайлов(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОбновляемыеЗначения(Данные) 
	
	Если Данные.Свойство("status") И НЕ Объект.СтатусЗаявки.Код = Данные.status Тогда
		Объект.СтатусЗаявки = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.НайтиПоКоду(Данные.status);
		Если Объект.СтатусЗаявки = ПредопределенноеЗначение("Справочник.СтатусыЗаявокНаОдобрениеОбъекта.ВозвратНаДоработку") ИЛИ НЕ ЗначениеЗаполнено(Объект.СтатусЗаявки) Тогда
			Объект.УспешнаяОтправка = Ложь;
		Иначе
			Объект.УспешнаяОтправка = Истина;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Статус заявки обновлен на " + Объект.СтатусЗаявки);
		Объект.ДатаУстановкиСтатуса = ТекущаяДата();		
		Если Объект.СтатусЗаявки = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.ОбъектНеСоответствуетТребованиямБанка 
			ИЛИ Объект.СтатусЗаявки = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.ОтказКлиента
			ИЛИ Объект.СтатусЗаявки = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.НеКредитуем Тогда 
			Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Отказ");
		ИначеЕсли Объект.СтатусЗаявки = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.ОбъектСоответствуетТребованиямБанка ИЛИ Объект.СтатусЗаявки = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.ОбъектСоответствуетПриУсловии Тогда
			Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Одобрение");
		Иначе
			Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Отправка");			
		КонецЕсли;		
		Модифицированность = Истина;
		Если НЕ Данные.Свойство("history") Тогда
			РегНаб = РегистрыСведений.ИсторияСтатусовИпотечныхЗаявок.СоздатьНаборЗаписей();
			РегНаб.Отбор.ИпотечнаяЗаявка.Установить(Объект.Ссылка);		
			РегНаб.Прочитать();		
			Попытка				
				Date = ТекущаяДата();
				Status = Справочники.СтатусыЗаявокНаОдобрениеОбъекта.НайтиПоКоду(Данные.status, Истина);					
				Если НЕ ЗаявкиНаКредитRestAPI.ЗаписьЕстьВНаборе(РегНаб, Date, Status) Тогда		
					НовЗапись = РегНаб.Добавить();
					НовЗапись.ИпотечнаяЗаявка = Объект.Ссылка;
					НовЗапись.Date = Date;
					НовЗапись.Status = Status;			
				КонецЕсли;
				Если РегНаб.Модифицированность() Тогда
					РегНаб.Записать(Истина);
				КонецЕсли;			
			Исключение				
			КонецПопытки;								
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("requestId") И НЕ Объект.ID_ЗаявкиНаКредит = Данные.requestId Тогда
		Объект.ID_ЗаявкиНаКредит = Данные.requestId;
	КонецЕсли;
	
	Если Данные.Свойство("approvalId") И НЕ Объект.approvalId = Данные.approvalId Тогда
		Попытка
			Объект.approvalId = Данные.approvalId;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	ОтправлятьОповещение = Ложь;
	Если Данные.Свойство("history") И НЕ Данные.history = Неопределено Тогда
		КомментарийСтатуса = "";
		ЗаявкиНаКредитRestAPI.ЗаполнитьИсториюСтатусовЗапросаНаОдобрение(Данные.history, Объект.Ссылка, КомментарийСтатуса, ОтправлятьОповещение);
		Если НЕ Объект.КомментарийСтатуса = КомментарийСтатуса Тогда 
			Объект.КомментарийСтатуса = КомментарийСтатуса;
			Модифицированность = Истина;
			ОтправлятьОповещение = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("comments") И НЕ Данные.comments = Неопределено Тогда
		Комментарии = ЗаявкиНаКредитRestAPI.ЗаполнитьКомментарииЗапросаНаОдобрение(Данные.comments, Объект.КомментарииЗаявки.Выгрузить(), Модифицированность);
		Если НЕ Комментарии = Неопределено И Модифицированность Тогда
			Объект.КомментарииЗаявки.Загрузить(Комментарии);
		КонецЕсли;
	КонецЕсли;
		
	Если Модифицированность Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если ОтправлятьОповещение Тогда
		Попытка
			ОтправитьОповещение();	
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПередОтправкой(Отказ)
	
	Отказ = НЕ ПроверитьЗаполнение();	
	Если НЕ Отказ Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ПараметрыПодключения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнен параметры подключения к сервису подачи заявок.");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.transactID) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнен Номер транзакта", Объект.Ссылка, "transactID", "Объект", Отказ);  	
			Возврат;
		КонецЕсли;		
				
		Если НЕ ЗначениеЗаполнено(Объект.ФИОКлиента) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнено ФИО Клиента", Объект.Ссылка, "ФИОКлиента", "Объект", Отказ);
			Возврат;
		КонецЕсли;		
						
		Если НЕ Объект.ПрикрепленныеФайлы.Количество() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет прикрепленных файлов к заявке", Объект.Ссылка, "ПрикрепленныеФайлы", "Объект", Отказ);
			Возврат;			
		КонецЕсли;
		
		Если НЕ Объект.КомментарииЗаявки.Количество() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет комментариев к заявке", Объект.Ссылка, "КомментарииЗаявки", "Объект", Отказ);
			Возврат;			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.ID_Заявки) Тогда	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрос уже был отправлен", Объект.Ссылка, "ID_Заявки", "Объект", Отказ);
			Возврат;			
		КонецЕсли;				
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	АдминистрированиеЗаявок = УправлениеДоступом.ЕстьРоль("РаботаСИпотечнымиЗаявками_Администратор", , Пользователи.ТекущийПользователь()) ИЛИ УправлениеДоступом.ЕстьРоль("ПолныеПрава", , Пользователи.ТекущийПользователь());
	
	Элементы.ФормаГруппаТестироваине.Видимость =  АдминистрированиеЗаявок;
	Элементы.СтатусЗаявки.ТолькоПросмотр = НЕ АдминистрированиеЗаявок; 
	
	Элементы.ГруппаСопутствующиеДанные.ТолькоПросмотр = Объект.УспешнаяОтправка И НЕ АдминистрированиеЗаявок; 
	Элементы.ПрикрепленныеФайлы.КоманднаяПанель.ТолькоПросмотр = Объект.УспешнаяОтправка И НЕ АдминистрированиеЗаявок; 
	
	Элементы.ПрикрепленныеФайлыкнДобавитьФайл.Доступность = НЕ Объект.УспешнаяОтправка ИЛИ АдминистрированиеЗаявок;
	Элементы.ПрикрепленныеФайлыкнОткрытьКарточкуФайла.Доступность = НЕ Объект.УспешнаяОтправка ИЛИ АдминистрированиеЗаявок;
	Элементы.ПрикрепленныеФайлыкнУдалитьФайл.Доступность = НЕ Объект.УспешнаяОтправка ИЛИ АдминистрированиеЗаявок;
	//Элементы.ПрикрепленныеФайлыкнПросмотрФайла.Доступность = НЕ Объект.УспешнаяОтправка ИЛИ АдминистрированиеЗаявок;
	Элементы.ПрикрепленныеФайлыОбновитьФайлы.Доступность = НЕ Объект.УспешнаяОтправка ИЛИ АдминистрированиеЗаявок;
	
	Элементы.КомментарииЗаявки.КоманднаяПанель.ТолькоПросмотр = Объект.УспешнаяОтправка И НЕ АдминистрированиеЗаявок;
	Элементы.КомментарииЗаявкикнДобавитьСтрокиКомментария.Доступность = НЕ Объект.УспешнаяОтправка ИЛИ АдминистрированиеЗаявок;
	
	Если Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Отправка") Тогда
		Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.Телефония_Ожидание;     
	ИначеЕсли Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Отказ") Тогда
		Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.Телефония_АктивнаяЛиния;
	ИначеЕсли Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Одобрение") Тогда
		Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.Телефония_СвободнаяЛиния;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуФайлов()
		
	КолВоФайлов = Объект.ПрикрепленныеФайлы.Количество();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Файлы.Ссылка КАК Ссылка,
	|	Файлы.ДатаСоздания КАК ДатаСоздания
	|ИЗ
	|	Справочник.ЗапросНаОдобрениеОбъектаПрисоединенныеФайлы КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла
	|	И Файлы.ВладелецФайла ССЫЛКА Документ.ЗапросНаОдобрениеОбъекта
	|	И НЕ Файлы.ПометкаУдаления";
				   
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка); 			   
	
	РезультатЗапроса = Запрос.Выполнить();	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекущиеФайлы = Новый Массив;
		Выборка = РезультатЗапроса.Выбрать();		
		Если КолВоФайлов < Выборка.Количество() Тогда
			Пока Выборка.Следующий() Цикл
				НайденныеСтроки = Объект.ПрикрепленныеФайлы.НайтиСтроки(Новый Структура("Файл", Выборка.Ссылка));
				Если НЕ НайденныеСтроки.Количество() Тогда
					НоваяСтрока = Объект.ПрикрепленныеФайлы.Добавить();
					НоваяСтрока.Файл = Выборка.Ссылка;
					НоваяСтрока.Отправлять = Истина;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Пока Выборка.Следующий() Цикл
				НайденныеСтроки = Объект.ПрикрепленныеФайлы.НайтиСтроки(Новый Структура("Файл", Выборка.Ссылка));
				Для каждого СтрокаФайл Из НайденныеСтроки Цикл 
					ТекущиеФайлы.Добавить(СтрокаФайл);
				КонецЦикла;
			КонецЦикла;			
		КонецЕсли;		
		Если ТекущиеФайлы.Количество() Тогда
			Объект.ПрикрепленныеФайлы.Очистить();
			Для каждого СтрокаФайл Из ТекущиеФайлы Цикл 
				НоваяСтрока = Объект.ПрикрепленныеФайлы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаФайл);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;	
	Если НЕ КолВоФайлов = Объект.ПрикрепленныеФайлы.Количество() Тогда
		Модифицированность = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьОповещение()	
	ЗаявкиНаКредитRestAPI.ОтправитьОповещениеОбИзмененииСтатуса(ЗаявкиНаКредитRestAPI.СобратьСтруктуруПисьмаДляМенеджера(РеквизитФормыВЗначение("Объект"), Истина));		
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОповещенияОЗавершенииВводаКомментарияОтказа(Строка, ДополнительныеПараметры) Экспорт

	Если НЕ ЗначениеЗаполнено(Строка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нужно указать комментарий");
		Возврат;
	КонецЕсли;
	
	Объект.КомментарийСтатуса = Строка;	
	Ошибки = "";	
	//Объект.УспешнаяОтправка = Ложь;
	Идентификатор = ЗаявкиНаКредитRestAPI.ИзменитьСтатусЗапросаНаОдобрение(Объект.ПараметрыПодключения, ПредопределенноеЗначение("Справочник.СтатусыЗаявокНаОдобрениеОбъекта.ОтказКлиента"), Объект.ID_Заявки, Объект.КомментарийСтатуса, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
	Если Ошибки = "" Тогда
		Если Объект.ID_Заявки = Идентификатор И ЗначениеЗаполнено(Идентификатор) Тогда			
			Модифицированность = Истина;
			Объект.СтатусЗаявки = ПредопределенноеЗначение("Справочник.СтатусыЗаявокНаОдобрениеОбъекта.ОтказКлиента");
			Объект.СостояниеЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияИпотечныхЗаявок.Отказ");
			Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Статус обновлен на " + Объект.СтатусЗаявки);
			УправлениеВидимостьюДоступностью();
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка обновления статуса заявки: " + Ошибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискНаСервере()

	СписокВыбораПоиска.Очистить();
	Ошибки = ""; 	
	Данные = ЗаявкиНаКредитRestAPI.ВыполнитьПоискКлиента(Объект.ПараметрыПодключения, ПолеПоиска, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
	Если Ошибки = "" Тогда
		Если ТипЗнч(Данные) = Тип("Массив") Тогда
			Для каждого Элемент Из Данные Цикл
				СтруктураЭлемента = Новый Структура;
				СтруктураЭлемента.Вставить("transactId", Элемент.transactId);
				СтруктураЭлемента.Вставить("name", Элемент.client.name);
				СтруктураЭлемента.Вставить("emailAddress", Элемент.client.emailAddress);
				СтруктураЭлемента.Вставить("phoneNumber", Элемент.client.phoneNumber);
				СтруктураЭлемента.Вставить("passportNumber", Элемент.client.passportNumber);
				СтруктураЭлемента.Вставить("birthDate", Дата(СтрЗаменить(Элемент.client.birthDate, "-", "")));
				СтруктураЭлемента.Вставить("office", Справочники.ОтделенияИпотечныхБанков.НайтиПоРеквизиту("ID", Элемент.office.id));
				СписокВыбораПоиска.Добавить(СтруктураЭлемента, СтруктураЭлемента.name + " " + Элемент.client.birthDate + " г.р. " + "(" + СтруктураЭлемента.transactId + ")");					
			КонецЦикла;
		КонецЕсли;					
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка поиска клиента: " + Ошибки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбора(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = ВыбранныйЭлемент.Значение;	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("transactId") Тогда
		ЭлементСписка = СписокВыбораПоиска.НайтиПоЗначению(ВыбранноеЗначение.transactId);
		Для каждого ЭлементСписка Из СписокВыбораПоиска Цикл 
			Если ЭлементСписка.Значение.transactId = ВыбранноеЗначение.transactId Тогда
				ПолеПоиска = ЭлементСписка.Представление;
				ЗаполнитьПоРезультатамПоиска(ЭлементСписка.Значение);
				Модифицированность = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоРезультатамПоиска(СтруктураПоиска)
	
	Объект.transactID = СтруктураПоиска.transactId;
	Объект.ФИОКлиента = СтруктураПоиска.name;
	Объект.EmailКлиента = СтруктураПоиска.emailAddress;
	Объект.НомерТелефонаКлиента = СтруктураПоиска.phoneNumber;
	Объект.СерияНомерПаспорта = СтруктураПоиска.passportNumber;
	Объект.ДатаРожденияКлиента = СтруктураПоиска.birthDate;
	Объект.ОтделениеБанка = СтруктураПоиска.office;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ЗнчПоиска = Элемент.ТекстРедактирования;
	ДанныеВыбора = СписокВыбораПоиска;//ПолучитьДанныеВыбораПоиска(ЗнчПоиска);	
	ПолеПоиска = ЗнчПоиска;
	
КонецПроцедуры

&НаСервере
Процедура РекомендуемыйБанкПриИзмененииНаСервере()
	
	Объект.ПараметрыПодключения = Объект.РекомендуемыйБанк.ПараметрыПодключения;		
	УправлениеВидимостьюДоступностью();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОЗаписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	Записать();	
	
	Если ДополнительныеПараметры.Свойство("CallBack") И ТипЗнч(ДополнительныеПараметры.CallBack) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.CallBack);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОтправку_Асинхр(Результат, ДополнительныеПараметры) Экспорт	
	ОтправитьЗапросаНаОдобрение();	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаМенеджеру(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ОтправитьОповещение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлы_Асинхр(Результат, ДополнительныеПараметры) Экспорт	
	
	РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ЭтаФорма.УникальныйИдентификатор);
	ОбновитьТаблицуФайлов();
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаСтрокиКомментария(Комментарий, Параметры) Экспорт

	Если НЕ Комментарий = Неопределено Тогда		
		ТекущиеДанные = Элементы.КомментарииЗаявки.ТекущиеДанные;
		Если НЕ ТекущиеДанные = Неопределено Тогда	
			ТекущиеДанные.Комментарий = Комментарий;
			ТекущиеДанные.ДатаДобавления = ТекущаяДата();
			ТекущиеДанные.Отправлять = Истина;
		КонецЕсли;
 	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросВыводитьХодОбновления(Результат, ДополнительныеПараметры) Экспорт
		
	Если ДополнительныеПараметры.Свойство("CallBack") И ТипЗнч(ДополнительныеПараметры.CallBack) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.CallBack, Результат = КодВозвратаДиалога.Да);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеОЗапросе_Асинхр(Результат, ДополнительныеПараметры) Экспорт	

	Ошибки = "";	
	Если ЗначениеЗаполнено(Объект.ID_Заявки) Тогда		
		Данные = ЗаявкиНаКредитRestAPI.ПолучитьДанныеЗапросаНаОдобрение(Объект.ПараметрыПодключения, Объект.ID_Заявки, Token, X_Auth_User, Объект.ТестоваяЗаявка, Ошибки);
		Если Ошибки = "" Тогда
			Если ТипЗнч(Данные) = Тип("Структура") Тогда
				Если Результат Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Данные заявки " +  СтрЗаменить(Объект.ID_Заявки, Символы.НПП, "") + ":");
					Для каждого Элемент Из Данные Цикл
						Если ТипЗнч(Элемент.Значение) = Тип("Строка")
							ИЛИ ТипЗнч(Элемент.Значение) = Тип("Число") 
							ИЛИ ТипЗнч(Элемент.Значение) = Тип("Булево")
							ИЛИ Элемент.Значение = Неопределено Тогда
							Сообщить(Элемент.Ключ + " : " + ?(ТипЗнч(Элемент.Значение) = Тип("Число"), СтрЗаменить(Элемент.Значение, Символы.НПП, ""), Элемент.Значение));	
						ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Массив") Тогда
							Сообщить(Элемент.Ключ + ": ");
							Для каждого ЭлементМассива Из Элемент.Значение Цикл
								Если Элемент.Ключ = "comments" Тогда
									Сообщить(Символы.Таб + "(" + СтрЗаменить(ЭлементМассива.id, Символы.НПП, "") + "):" + ЭлементМассива.comment + " : " + ЭлементМассива.name + " " + ЭлементМассива.id);
								ИначеЕсли Элемент.Ключ = "documents" Тогда
									Сообщить(Символы.Таб + "(" + СтрЗаменить(ЭлементМассива.id, Символы.НПП, "") + "):" + ЭлементМассива.name + " : " + ЭлементМассива.path + " : " + ЭлементМассива.create_date);
								ИначеЕсли Элемент.Ключ = "history" Тогда
									Дата = (Дата(1970,1,1,0,0,0) + ЭлементМассива.date);
									Сообщить(Символы.Таб + "(" + СтрЗаменить(ЭлементМассива.title, Символы.НПП, "") + "):" + ЭлементМассива.comment + "[" + Дата + "]"); 
								КонецЕсли;
							КонецЦикла;		
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				УстановитьОбновляемыеЗначения(Данные);
			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка при получении данных заявки: " + Ошибки);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заявка не отправлена");		
	КонецЕсли;	
	
	УправлениеВидимостьюДоступностью();	

КонецПроцедуры

#КонецОбласти
