<%@ Page Title="" Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="archivos.aspx.cs" Inherits="subir_archivos" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
      <h1>
       Subir archivos
        <small><asp:Label ID="lblnombre" runat="server" Text=""></asp:Label></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="../inicio/inicio.aspx"><i class="fa fa-dashboard"></i> Inicio</a></li>
        <%--<li><a href="#">Bienvenido</a></li>--%>
        <li class="active">Archivos</li>
      </ol>
    </section>

        
    <!-- Main content -->
    <section class="content">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

         <asp:UpdatePanel ID="UpdatePanel2" runat="server">
          <ContentTemplate>

         <table width="300px" class="tb_nuevo">
        <tr>
          <td align="left" colspan="2">
            Archivos:
          </td>
        </tr>
        <tr>
           <td align="left" colspan="2">
             <telerik:RadUpload ID="rapupX" runat="server"  ControlObjectsVisibility="RemoveButtons, AddButton" Culture="es-MX"  MaxFileInputsCount="5">
               <Localization Add="Otro Archivo" Remove="Quitar" Select="Buscar" />
             </telerik:RadUpload>
            
          <%--    <telerik:RadUpload ID="rapupX" runat="server" 
                        ControlObjectsVisibility="RemoveButtons, AddButton" Culture="es-MX" 
                        MaxFileInputsCount="10">
                    <Localization Add="Otro anexo" Remove="Quitar" Select="Seleccionar" />
                    </telerik:RadUpload>--%>
           </td>
        </tr>
        <tr>
            <td colspan="2"> 
                <br />
            </td>
        </tr>
        <tr>
             <td align="left" colspan="2">
            
                    Mes:
                    <asp:DropDownList ID="cbomes" runat="server">
                        <asp:ListItem Value="1">Enero</asp:ListItem>
                        <asp:ListItem Value="2">Febrero</asp:ListItem>
                        <asp:ListItem Value="3">Marzo</asp:ListItem>
                        <asp:ListItem Value="4">Abril</asp:ListItem>
                        <asp:ListItem Value="5">Mayo</asp:ListItem>
                        <asp:ListItem Value="6">Junio</asp:ListItem>
                        <asp:ListItem Value="7">Julio</asp:ListItem>
                        <asp:ListItem Value="8">Agosto</asp:ListItem>
                        <asp:ListItem Value="9">Septiembre</asp:ListItem>
                        <asp:ListItem Value="10">Octubre</asp:ListItem>
                        <asp:ListItem Value="11">Noviembre</asp:ListItem>
                        <asp:ListItem Value="12">Diciembre</asp:ListItem>
                    </asp:DropDownList>
            </td>
        </tr>
         <tr>
            <td colspan="2"> 
                <br />
            </td>
        </tr>
        <tr>
            <td align="left" colspan="2">
                 Año:
                    <asp:DropDownList ID="cboanio" runat="server">
                        <asp:ListItem>2019</asp:ListItem>
                        <asp:ListItem>2020</asp:ListItem>
                        <asp:ListItem>2021</asp:ListItem>
                        <asp:ListItem>2022</asp:ListItem>
                        <asp:ListItem>2023</asp:ListItem>
                        <asp:ListItem>2024</asp:ListItem>
                        <asp:ListItem>2025</asp:ListItem>
                    </asp:DropDownList>
            </td>
        </tr>
         <tr>
            <td colspan="2"> 
                <br />
            </td>
        </tr>
       
        </table>
         </ContentTemplate>
        </asp:UpdatePanel>

         <table>
        <tr>
            <td >
               <asp:Button ID="cmdsubir" runat="server" onclick="cmdguardar_Click" Text="Subir" Width="56px" />
            </td>  
            <td>
              <asp:Button ID="cmdbuscar" runat="server" Text="Buscar"  onclick="cmdbuscar_Click"></asp:Button>
            </td>   
        </tr>
        </table>

          <asp:UpdatePanel ID="UpdatePanel1" runat="server">
          <ContentTemplate>
           
                <asp:Label ID="lblmensaje" runat="server" Text=""></asp:Label>
                <br/>
                <asp:GridView ID="dtgnominas" runat="server" AutoGenerateColumns="False" 
                    GridLines="None" CellPadding="4" ForeColor="#333333" AllowPaging="True" 
                        onrowcommand="dtgnominas_RowCommand" 
                        onpageindexchanging="dtgnominas_PageIndexChanging" 
                        onselectedindexchanged="dtgnominas_SelectedIndexChanged"
                        >
                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                            <Columns>
                               
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <asp:Label ID="iIdInfoKiosko" runat="server" Text='<%# Bind("iIdArchivosAlta") %>' Visible="false" ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Fecha">
                                    <ItemTemplate>
                                        <asp:Label Width="100px" style=" text-align:right;" ID="mes" runat="server" Text='<%# Bind("fecha") %>'  Visible="true" ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:TemplateField HeaderText="Archivo">
                                    <ItemTemplate>
                                        <asp:Label Width="200px" style=" text-align:center;" ID="nombrearchivo" runat="server" Text='<%# Bind("cNombreArchivo") %>'  Visible="true" ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                

                                <asp:CommandField ButtonType="Image" HeaderText="" 
                                     SelectImageUrl="../imagenes/pdf2.png"
                                    ShowSelectButton="True" >
                                    
                                <HeaderStyle Width="40px" />
                                </asp:CommandField>
                                          
                                        
                            </Columns>
                            <EditRowStyle BackColor="#999999" />
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="False" ForeColor="#333333" />
                            <SortedAscendingCellStyle BackColor="#E9E7E2" />
                            <SortedAscendingHeaderStyle BackColor="#506C8C" />
                            <SortedDescendingCellStyle BackColor="#FFFDF8" />
                            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                    </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
       
    </section>



</asp:Content>

