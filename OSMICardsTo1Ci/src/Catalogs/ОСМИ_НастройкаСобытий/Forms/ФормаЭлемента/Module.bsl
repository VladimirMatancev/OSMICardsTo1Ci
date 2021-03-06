&НаКлиенте
Процедура ОбновитьОтображение()
	ЭтаФорма.Элементы.ГруппаОбъектМетаданных.Доступность = (Объект.СпособПолученияДанных = 0);	
	
	ЭтаФорма.Элементы.ОбъектКонфигурации.СписокВыбора.Очистить();
	
	Массив = ПолучитьССервера(Объект.СпособПолученияДанных);
	
	ЭтаФорма.Элементы.ОбъектКонфигурации.СписокВыбора.ЗагрузитьЗначения(Массив);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьССервера(СпособПолучения)
	МассивКлассовМетаданных = Новый Массив;
	
	МТД = новый Массив;
	
	
	Если СпособПолучения = 0 Тогда
		МассивКлассовМетаданных.Добавить("Справочники");
		МассивКлассовМетаданных.Добавить("Документы");
	ИначеЕсли СпособПолучения = 1 Тогда
		МассивКлассовМетаданных.Добавить("РегистрыСведений");
	ИначеЕсли СпособПолучения = 2 Тогда	
		МассивКлассовМетаданных.Добавить("РегистрыНакопления");
	иначе
		
	КонецЕсли;
	
	Для каждого КлассМетаданных Из МассивКлассовМетаданных Цикл 	
		Для Каждого ОбъектМетаданных Из Метаданные[КлассМетаданных] Цикл
			МТД.Добавить(ОбъектМетаданных.ПолноеИмя());
		КонецЦикла;
	КонецЦикла;
	
	Возврат МТД;
КонецФункции

&НаКлиенте
Процедура СпособПолученияДанныхПриИзменении(Элемент)
	ОбновитьОтображение();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьОтображение();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКод()
	Текст = 
	"ВЫБРАТЬ Таблица.$ИмяПоля$ ИЗ $ИмяТаблицы$ КАК Таблица Где $УсловияЗапроса$";
	
	УсловияЗапроса = "Истина и";
	ПараметрыЗапроса = "";
	
	
	Для Каждого Элем из Объект.Отборы Цикл
		УсловияЗапроса =УсловияЗапроса + " Таблица." + Элем.Параметр + " = &" + Элем.Параметр + " и";
		
		ПараметрыЗапроса = 
		ПараметрыЗапроса 
		+ "Запрос.УстановитьПараметр("""+Элем.Параметр 
		+ """,Отборы.Получить("+(Элем.НомерСтроки-1)+").Значение);";   
	КонецЦикла;
	
	УсловияЗапроса = Лев(УсловияЗапроса,СтрДлина(УсловияЗапроса)-1);
	
	Текст = СтрЗаменить(Текст,"$ИмяПоля$",Объект.Поле);
	Текст = СтрЗаменить(Текст,"$ИмяТаблицы$",Объект.ОбъектКонфигурации);
	Текст = СтрЗаменить(Текст,"$УсловияЗапроса$",УсловияЗапроса);
	
	Текст = 
	"	Запрос = Новый Запрос;
	|	Запрос.Текст = """+Текст+""";
	|   Запрос.УстановитьПараметр(""Источник"",Источник); 
	|	" + ПараметрыЗапроса + " 
	|   Выборка = Запрос.выполнить().выбрать();
	|   Массив = Новый Массив;
	|
	|	Пока Выборка.Следующий() Цикл
	|   	Массив.Добавить(Выборка."+Объект.Поле+");
	|   КонецЦикла;
	|	Результат = Массив;";
	
	Объект.ТекстПрограммы = Текст;	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКодКоманда(Команда)
	ОбновитьКод()
КонецПроцедуры

&НаСервере
Функция СоздатьРегламентноеЗаданиеНаСервере()
	Об = РеквизитФормыВЗначение("Объект");
	
	Отбор = Новый Структура;
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные",      Метаданные.РегламентныеЗадания.ОСМИ_РегламентноеЗадание);
	Отбор.Вставить("Предопределенное",Ложь);
	Отбор.Вставить("Ключ",Об.Ссылка.УникальныйИдентификатор());
	Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(отбор);
	
	Если Задания.Количество() > 0 тогда
		Задание = Задания[0];
	Иначе
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ОСМИ_РегламентноеЗадание);
		Задание.Параметры.Добавить(Об.Ссылка);
		Задание.Ключ = Об.Ссылка.УникальныйИдентификатор();	
		Задание.Использование = Истина;
		Задание.Наименование = Об.Наименование;
		Задание.Записать();
		
		//Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Задание.Расписание);  		
		//Диалог.Показать() 		
	КонецЕсли;
	
	Возврат Задание.Расписание;
КонецФункции

&НаКлиенте
Процедура СоздатьРегламентноеЗадание(Команда)
	Расписание = СоздатьРегламентноеЗаданиеНаСервере();
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);  		
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасписание",ЭтотОбъект); 
	
	Диалог.Показать(Оповещение); 	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасписание(РАсписание,Параметры) Экспорт
	УстановитьРасписаниеНаСервере(Расписание);
КонецПроцедуры

&НаСервере
Процедура УстановитьРасписаниеНаСервере(Расписание) Экспорт
	Об = РеквизитФормыВЗначение("Объект");
	
	Отбор = Новый Структура;
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные",      Метаданные.РегламентныеЗадания.ОСМИ_РегламентноеЗадание);
	Отбор.Вставить("Предопределенное",Ложь);
	Отбор.Вставить("Ключ",Об.Ссылка.УникальныйИдентификатор());
	Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(отбор);
	
	Если Задания.Количество() > 0 тогда
		Задание = Задания[0];
		Задание.Расписание = РАсписание;
		Задание.Записать();		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ВыполнитьСейчасНаСервере()
	Об = РеквизитФормыВЗначение("Объект");
	Об.ОтработатьСобытие("РегламентноеЗадание"); 
	//ОСМИ Сделать 12.09.2016
	// 
	//	Добавить форму выбора
	//
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСейчас(Команда)
	ВыполнитьСейчасНаСервере();
КонецПроцедуры
