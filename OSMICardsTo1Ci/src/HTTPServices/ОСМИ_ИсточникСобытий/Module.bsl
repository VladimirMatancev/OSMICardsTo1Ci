
Функция ЗапросANY(Запрос)
	
	СистемаВключена = ПолучитьФункциональнуюОпцию("ОСМИ_ПодсистемаВключена");
	Если НЕ СистемаВключена Тогда
		Ответ = Новый HTTPСервисОтвет(400);
		Возврат Ответ;
	КонецЕсли;
	
	Если Запрос.HTTPМетод = "GET" Тогда
		
	Иначе
		
	КонецЕсли;
	
	//Серверу ответ не интересен.
	Ответ = Новый HTTPСервисОтвет(200);
	
	Возврат Ответ;
	
КонецФункции
